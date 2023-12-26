//
//  Twitter_Notification_AppApp.swift
//  Twitter Notification App
//
//  Created by Moshiur Rahman on 10/4/23.
//

import SwiftUI

@main
struct Twitter_Notification_AppApp: App {

    var body: some Scene {
        WindowGroup {
            NewsView()
            .frame(minWidth: NSScreen.main?.frame.width, minHeight: (NSScreen.main?.frame.height ?? 820) - 140)
            .preferredColorScheme(.light)
        }
    }
}


