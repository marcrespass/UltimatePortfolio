//
//  DataController+Reminders.swift
//  UltimatePortfolio
//
//  Created by Marc Respass on 6/2/21.
//

import Foundation
import UserNotifications

// MARK: - Local Notifications
extension DataController {
    // Called by EditProjectView
    func addReminders(for project: Project, completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .notDetermined:
                    self.requestNotifications { success in
                        if success {
                            self.placeReminders(for: project, completion: completion)
                        } else {
                            DispatchQueue.main.async { completion(false) }
                        }
                    }
                case .authorized:
                    self.placeReminders(for: project, completion: completion)
                default:
                    DispatchQueue.main.async {
                        completion(false)
                    }
            }
        }
    }

    func removeReminders(for project: Project) {
        let center = UNUserNotificationCenter.current()
        let projectID = project.objectID.uriRepresentation().absoluteString
        center.removePendingNotificationRequests(withIdentifiers: [projectID])
    }

    // request permission to show a notification
    private func requestNotifications(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }

    private func placeReminders(for project: Project, completion: @escaping (Bool) -> Void) {
        // 1 content of notification - what to show
        let content = UNMutableNotificationContent()
        content.title = project.projectTitle
        content.sound = .default

        if let projectDetail = project.detail {
            content.subtitle = projectDetail
        }

        // 2 trigger - when to show
        let components = Calendar.current.dateComponents([.hour, .minute], from: project.reminderTime ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        // 3 wrap content + trigger + id
        let projectID = project.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: projectID, content: content, trigger: trigger)

        // 4 pass data to notification center
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
