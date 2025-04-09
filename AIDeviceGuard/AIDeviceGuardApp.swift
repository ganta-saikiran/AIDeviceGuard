//
//  AIDeviceGuardApp.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 06/04/25.
//

import SwiftUI
import AIComponents
import FirebaseCore

@main
struct AIDeviceGuardApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            AIDGHomepageTabView()
        }
    }
}
