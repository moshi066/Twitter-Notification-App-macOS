//
//  AppDelegate.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 12/19/23.
//

import Cocoa
import SwiftUI
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {
    @Published var isNewsItemsAvaialble = false
    var window: NSWindow!
    let pushMessagingUseCase = PushMessagingUseCase(pushMessagingRepository: PushMessagingRepositoryImpl(baseUrl: URL(string: "http://cryptobot-user-feedback-api-prod.eba-usyp3675.ap-northeast-1.elasticbeanstalk.com/")!))
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                DispatchQueue.main.async {
                    NSApp.registerForRemoteNotifications()
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        
        
        self.pushMessagingUseCase.execute(registrationToken: token)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [unowned self] completion in
                    if case .failure(let error) = completion {
                        print(error.localizedDescription)
                    }
                },
                receiveValue: { [unowned self] status in
                    print("token status: ", status)
                })
    }
    
    func application(_ application: NSApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String: Any]) {
        self.isNewsItemsAvaialble = true
        NSApp.windows.first?.orderFrontRegardless()
    }
}
