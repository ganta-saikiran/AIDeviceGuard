//
//  AIDGSuccessScreenRouter.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 08/04/25.
//

import SwiftUI

struct AIDGSuccessScreenRouter {
    static func makeView(action: @escaping (AIDGHomePageAction) -> Void, _ employeeName: String, _ deviceName: String) -> some View {
        AIDGSuccessScreen(action: action, deviceName: deviceName, employeeName: employeeName)
    }
}
