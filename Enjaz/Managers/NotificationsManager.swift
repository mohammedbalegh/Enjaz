import UIKit

struct NotificationsManager {
	
	static func requestNotificationsPermission() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound, .badge]) {_,_ in }
	}
	
	static func scheduleNotification(id: String, title: String? = nil, body: String? = nil, date: Date) {
		let content = UNMutableNotificationContent()
		if let title = title {
			content.title = title
		}
		
		if let body = body {
			content.body = body
		}
		
		content.sound = .default
		
		let dateComponents = DateAndTimeTools.getDateComponentsOf(date, forCalendarIdentifier: Calendar.current.identifier)
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
		let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
		
		scheduleNotificationRequest(request)
	}
	
	static func scheduleNotification(forItem item: ItemModel) {
		let notificationBody = item.name
		let itemDate = Date(timeIntervalSince1970: item.date)
		scheduleNotification(id: String(item.id), body: notificationBody, date: itemDate)
	}
	
	private static func scheduleNotificationRequest(_ request: UNNotificationRequest) {
		let notificationCenter = UNUserNotificationCenter.current()
		notificationCenter.add(request)
	}
		
	static func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
		let notificationCenter = UNUserNotificationCenter.current()
		notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
	}
		
}
