import UIKit

class DailyViewCell: UICollectionViewCell {
	let hourCellReuseIIdentifier = "hourCell"
	let hourLabels = Date.twelveHourFormatHourLabels
	
	var dailyViewHourModels: [DailyViewHourModel] = []
	
	var viewModel: DailyViewDayModel? {
		didSet {
			guard let viewModel = viewModel else { return }
			
			dailyViewHourModels = generateDailyViewHourModels(includedItemsInDay: viewModel.includedItems)
			
			let lastUnixTimeStamp = Date.generateDateObjectFromComponents(year: viewModel.year, month: viewModel.month, day: viewModel.dayNumber, hour: 23, calendarIdentifier: viewModel.calendarIdentifier).timeIntervalSince1970
			
			let isLastUnixTimeStampInPast = lastUnixTimeStamp < Date().timeIntervalSince1970
			
			if #available(iOS 14.0, *) {
				addItemBtn.isHidden = isLastUnixTimeStampInPast
			}
			
			dismissalPanGesture.isEnabled = true
			interactiveStartingPoint = nil
			dismissalAnimator = nil
			isDraggingDownToDismiss = false
				
			tableView.reloadData()
			scrollToFirstIncludedItem()
		}
	}
	
	lazy var dismissalPanGesture: UIPanGestureRecognizer = {
		let pan = UIPanGestureRecognizer()
		pan.maximumNumberOfTouches = 1
		pan.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
		pan.delegate = self
		return pan
	}()
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		tableView.register(HourTableViewCell.self, forCellReuseIdentifier: hourCellReuseIIdentifier)
		tableView.backgroundColor = .clear
		tableView.showsVerticalScrollIndicator = false
		tableView.contentInsetAdjustmentBehavior = .never
		
		tableView.delegate = self
		tableView.dataSource = self
		
		return tableView
	}()
	
	lazy var addItemBtn: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setBackgroundImage(UIImage(named: "addButton"), for: .normal)
		        
		if #available(iOS 14.0, *) {
			button.showsMenuAsPrimaryAction = true
			button.menu = getAddItemContextMenu { type in
                guard let viewModel = self.viewModel else {
                    return
                }
                
                let nextHour = Date().getDateComponents(forCalendarIdentifier: Calendar.current.identifier).hour! + 1

                let dateOfSelectedDay = Date.generateDateObjectFromComponents(year: viewModel.year, month: viewModel.month, day: viewModel.dayNumber, hour: nextHour, calendarIdentifier: Calendar.current.identifier)
                
                self.itemAdditionContextMenuActionHandler?(type, dateOfSelectedDay.timeIntervalSince1970)
			}
		} else {
			button.isHidden = true
		}
		
		return button
	}()
	
	func getAddItemContextMenu(actionHandler: @escaping (_ : ItemType) -> Void) -> UIMenu {
		let menuActions = [ItemType.goal, ItemType.demah, ItemType.achievement, ItemType.task].map { type -> UIAction in
			let actionTitle = String(format: NSLocalizedString("Add %@", comment: ""), type.localizedName).capitalizeOnlyFirstLetter()
			let actionImage = type.image?.withRenderingMode(.alwaysTemplate)
			
			return UIAction(
				title: actionTitle,
				image: actionImage
			) { _ in
				actionHandler(type)
			}
		}
		
		return UIMenu(title: "", children: menuActions)
	}
	
	lazy var addItemContextMenuConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
		return self.getAddItemContextMenu { type in
			self.itemAdditionContextMenuActionHandler?(type, self.additionTimeStamp)
		}
	}
	
	var itemSelectionHandler: ((_ selectedItem: [ItemModel]) -> Void)?
	var itemAdditionContextMenuActionHandler: ((_ type: ItemType, _ unixTimeStamp: Double?) -> Void)?
	var dismissPopup: ((_ animated: Bool) -> Void)?
	var blurOverlay: UIVisualEffectView?
	var dismissBtn: UIButton?
		
	var additionTimeStamp: Double?
	
	var interactiveStartingPoint: CGPoint?
	var dismissalAnimator: UIViewPropertyAnimator?
	
	var isDraggingDownToDismiss = false {
		didSet {
			let targetOpacity: CGFloat = isDraggingDownToDismiss ? 0 : 1
			UIView.animate(withDuration: 0.35) {
				self.blurOverlay?.alpha = targetOpacity
				self.dismissBtn?.alpha = targetOpacity
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .secondaryBackground
		layer.cornerRadius = 28
		clipsToBounds = true
		addGestureRecognizer(dismissalPanGesture)
				
		setupSubViews()
	}
	
	func setupSubViews() {
		setupTableView()
		setupAddItemBtn()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupTableView() {
		contentView.addSubview(tableView)
		tableView.constrainEdgesToCorrespondingEdges(of: contentView, top: 0, leading: 7, bottom: 0, trailing: -7)
	}
	
	func setupAddItemBtn() {
		contentView.addSubview(addItemBtn)
		
		NSLayoutConstraint.activate([
			addItemBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
			addItemBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
			addItemBtn.heightAnchor.constraint(equalToConstant: 45),
			addItemBtn.widthAnchor.constraint(equalToConstant: 45),
		])
	}
	
	func generateDailyViewHourModels(includedItemsInDay: [ItemModel]) -> [DailyViewHourModel] {
		var updatedHourModels: [DailyViewHourModel] = []
		
		for hour in hourLabels {
			updatedHourModels.append(DailyViewHourModel(hour: hour, includedItems: [], isShowingAllIncludedItems: false))
		}
		
		for item in includedItemsInDay {
			let itemDateComponents = Date.getDateComponentsOf(unixTimeStamp: item.date, forCalendarIdentifier: Calendar.current.identifier)
			updatedHourModels[itemDateComponents.hour ?? 0].includedItems.append(item)
		}
		
		return updatedHourModels
	}
	
	func showAllIncludedItems(at rowIndex: Int) {
		dailyViewHourModels[rowIndex].isShowingAllIncludedItems = true
		
		let otherIncludedItems = dailyViewHourModels[rowIndex].includedItems.dropFirst()
		var newRowsIndexPaths: [IndexPath] = []
		var index = 1
		for otherIncludedItem in otherIncludedItems {
			dailyViewHourModels.insert(DailyViewHourModel(hour: "", includedItems: [otherIncludedItem], isShowingAllIncludedItems: false), at: rowIndex + index)
			newRowsIndexPaths.append(IndexPath(row: rowIndex + index, section: 0))
			index += 1
		}
		
		tableView.insertRows(at: newRowsIndexPaths, with: .automatic)
	}
	
	func hideOtherIncludedItems(at rowIndex: Int) {
		dailyViewHourModels[rowIndex].isShowingAllIncludedItems = false
		
		let otherIncludedItems = dailyViewHourModels[rowIndex].includedItems.dropFirst()
		var toBeDeletedRowsIndexPaths: [IndexPath] = []
		
		for index in 1...otherIncludedItems.count {
			dailyViewHourModels.remove(at: rowIndex + 1)
			toBeDeletedRowsIndexPaths.append(IndexPath(row: rowIndex + index, section: 0))
		}
		
		tableView.deleteRows(at: toBeDeletedRowsIndexPaths, with: .automatic)
	}
	
	func scrollToFirstIncludedItem() {
		let indexPathOfFirstIncludedItem = getIndexPathOfFirstIncludedItem()
		tableView.scrollToRow(at: indexPathOfFirstIncludedItem, at: .middle, animated: false)
	}
	
	func getIndexPathOfFirstIncludedItem() -> IndexPath {
		for (index, dailyViewHourModel) in dailyViewHourModels.enumerated() {
			if dailyViewHourModel.includesItems {
				return IndexPath(row: index, section: 0)
			}
		}
		
		return IndexPath(row: 0, section: 0)
	}
	
	func getUnixTimeStampForRow(at indexPath: IndexPath) -> TimeInterval? {
		guard let viewModel = viewModel else{ return nil }
		let hourString = dailyViewHourModels[indexPath.row].hour
		
		guard !hourString.isEmpty else { return nil }
		
		guard let hour = Date.convert12HourFormatTo24HrFormatInt(hourString) else { return nil }
		let day = viewModel.dayNumber
		let month = viewModel.month
		let year = viewModel.year
		let calendarIdentifier = viewModel.calendarIdentifier
		
		let unixTimeStamp = Date.generateDateObjectFromComponents(year: year, month: month, day: day, hour: hour, calendarIdentifier: calendarIdentifier).timeIntervalSince1970
		
		return unixTimeStamp
	}
	
	func didSuccessfullyDragDownToDismiss(velocity: CGFloat) {
		let maximumVelocity: CGFloat = 1000, minimumDuration: CGFloat = 0.05, maximumDuration: CGFloat = 0.3
		let duration = TimeInterval(max(minimumDuration, (maximumDuration - (velocity / maximumVelocity) / 10)))
		
		UIView.animate(
			withDuration: duration,
			animations: {
				self.scale(to: 0.05)
				self.alpha = 0
			},
			completion: { _ in
				self.dismissPopup?(false)
			}
		)
	}
	
	func userWillCancelDismissalByDraggingToTop(velocityY: CGFloat) {}
	
	func didCancelDismissalTransition() {
		// Clean up
		interactiveStartingPoint = nil
		dismissalAnimator = nil
		isDraggingDownToDismiss = false
	}
	
	@objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
		guard isDraggingDownToDismiss else { return }

		let targetAnimatedViews = (superview as? UICollectionView)?.visibleCells
		let startingPoint: CGPoint
		
		if let point = interactiveStartingPoint {
			startingPoint = point
		} else {
			
			startingPoint = gesture.location(in: nil)
			interactiveStartingPoint = startingPoint
		}

		let currentLocation = gesture.location(in: nil)
		let progress = (currentLocation.y - startingPoint.y) / 100
		let targetShrinkScale: CGFloat = 0.5
		
		func createInteractiveDismissalAnimatorIfNeeded() -> UIViewPropertyAnimator {
			if let animator = dismissalAnimator {
				return animator
			} else {
				let animator = UIViewPropertyAnimator(duration: 0, curve: .linear, animations: {
					targetAnimatedViews?.forEach { $0.scale(to: targetShrinkScale) }
				})
				
				animator.isReversed = false
				animator.pauseAnimation()
				animator.fractionComplete = progress
				return animator
			}
		}

		switch gesture.state {
		case .began:
			dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()

		case .changed:
			dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()

			let actualProgress = progress
			let isDismissalSuccess = actualProgress >= 1.0

			dismissalAnimator!.fractionComplete = actualProgress

			if isDismissalSuccess {
				dismissalAnimator!.stopAnimation(false)
				dismissalAnimator!.addCompletion { [unowned self] (pos) in
					switch pos {
					case .end:
						let verticalVelocity = gesture.velocity(in: self).y
						self.didSuccessfullyDragDownToDismiss(velocity: verticalVelocity)
					default:
						fatalError("Must finish dismissal at end!")
					}
				}
				dismissalAnimator!.finishAnimation(at: .end)
			}

		case .ended, .cancelled:
			if dismissalAnimator == nil {
				didCancelDismissalTransition()
				return
			}
			
			
			dismissalAnimator!.pauseAnimation()
			dismissalAnimator!.isReversed = true

			gesture.isEnabled = false
			dismissalAnimator!.addCompletion { [unowned self] (pos) in
				self.didCancelDismissalTransition()
				gesture.isEnabled = true
			}
			dismissalAnimator!.startAnimation()
		default:
			fatalError("Impossible gesture state? \(gesture.state.rawValue)")
		}
	}
}

extension DailyViewCell: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		dailyViewHourModels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: hourCellReuseIIdentifier) as! HourTableViewCell
		cell.viewModel = dailyViewHourModels[indexPath.row]
		cell.unixTimeStamp = getUnixTimeStampForRow(at: indexPath)
		cell.row = indexPath.row
		cell.showAllBtnHandler = showAllIncludedItems
		cell.showLessBtnHandler = hideOtherIncludedItems
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let isShowingAllIncludedItems = dailyViewHourModels[indexPath.row].isShowingAllIncludedItems
		let items = dailyViewHourModels[indexPath.row].includedItems
		guard let firstItem = items.first else { return }
		
		itemSelectionHandler?(isShowingAllIncludedItems ? [firstItem] : items)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let viewModel = viewModel else { return UIView() }
		let numberOfItems = viewModel.includedItems.count
		
		let header = DailyViewTableViewCustomHeader()
		
		header.contentView.backgroundColor = backgroundColor
		header.dayNumberLabel.text = String(format: "%02d", viewModel.dayNumber)
		header.weekDayNameLabel.text = viewModel.weekDayName
		header.numberOfItemsLabel.text = String(numberOfItems) + " " + NSLocalizedString("Task", comment: "")
		
		if Locale.current.languageCode == "en" {
			header.numberOfItemsLabel.text! += numberOfItems > 1 ? "s" : ""
		}
		
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 70
	}
		
	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		guard let unixTimeStamp = getUnixTimeStampForRow(at: indexPath) else { return nil}
		
		let isUnixTimeStampInPast = unixTimeStamp < Date().timeIntervalSince1970
		
		guard !isUnixTimeStampInPast else { return nil }
		
		additionTimeStamp = unixTimeStamp
		
		return addItemContextMenuConfiguration
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if isDraggingDownToDismiss || (scrollView.isTracking && scrollView.contentOffset.y < 0) {
			isDraggingDownToDismiss = true
			scrollView.contentOffset = .zero
		}
		
		scrollView.showsVerticalScrollIndicator = !isDraggingDownToDismiss
	}
	
	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
		// Without this, when user drags down and lifts their finger quickly at the top, there'll be some scrolling going on.
		// This check prevents that.
		if velocity.y > 0 && scrollView.contentOffset.y <= 0 {
			scrollView.contentOffset = .zero
		}
	}
	
}

extension DailyViewCell: UIContextMenuInteractionDelegate {
	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		return addItemContextMenuConfiguration
	}
}

extension DailyViewCell: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
