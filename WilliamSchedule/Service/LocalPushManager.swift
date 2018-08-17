//
//  LocalPushManager.swift
//  Agenda Médica
//
//  Created by Andres Montoya on 8/16/18.
//  Copyright © 2018 WilliamsMedical. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class LocalPushManager: NSObject {
    static var shared = LocalPushManager()
    let center = UNUserNotificationCenter.current()
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if error ==  nil {
                print("Granted")
            }
        }
    }
    
    func sendPush(time: TimeInterval, name: String) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Tú próxima cita esta cerca", arguments: nil)
        content.body = NSString.localizedUserNotificationString(
            forKey: "Tú próxima cita  será en 5 minutos con \(name)",
            arguments: nil)
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        let request = UNNotificationRequest(identifier: name, content: content, trigger: trigger)
        center.add(request) { (error) in
            if error == nil {
                print("succes")
            }
        }
    }
    
}
