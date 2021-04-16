import UIKit

class MonthTasksScreenVC: MonthItemsScreenVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupItemViewsStack()
        itemsType = ItemType.task.id
    }
    
    var progressBar: ProgressBarView = {
        var view = ProgressBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScreen()
        progressBar.setValue(NSLocalizedString("Tasks of the month", comment: ""), NSLocalizedString("What tasks have you finished", comment: ""), monthItemModels.count, completedItemModels.count)
    }
    
    override func setItemCardViewsTitles() {
        dayItemsView.title = NSLocalizedString("Today's Tasks", comment: "")
        weekItemsView.title = NSLocalizedString("Week's Tasks", comment: "")
        monthItemsView.title = NSLocalizedString("Month's Tasks", comment: "")
        completedItemsView.title = NSLocalizedString("Completed Tasks", comment: "")
        
        dayItemsView.noCardsMessage = NSLocalizedString("No tasks", comment: "")
        weekItemsView.noCardsMessage = NSLocalizedString("No tasks", comment: "")
        monthItemsView.noCardsMessage = NSLocalizedString("No tasks", comment: "")
        completedItemsView.noCardsMessage = NSLocalizedString("No tasks", comment: "")
    }
    
    override func setupItemViewsStack() {
        scrollView.addSubview(itemViewsStack)
        scrollView.addSubview(progressBar)
        
        let padding = LayoutConstants.screenWidth * 0.053
        let height = itemViewsStack.calculateHeightBasedOn(arrangedSubviewHeight: 240)
        
        NSLayoutConstraint.activate([
            progressBar.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: LayoutConstants.screenHeight * 0.023),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            progressBar.heightAnchor.constraint(equalToConstant: LayoutConstants.screenHeight * 0.1477),
            itemViewsStack.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: LayoutConstants.screenHeight * 0.05),
            itemViewsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemViewsStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            itemViewsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemViewsStack.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
}
