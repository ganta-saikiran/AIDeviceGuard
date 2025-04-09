//
//  AIDGSuccessScreen.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 08/04/25.
//

import SwiftUI
import AIComponents

struct AIDGSuccessScreen: View {
    let action: (AIDGHomePageAction) -> Void
    var deviceName: String?
    var employeeName: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("\(employeeName ?? "") \(deviceName ?? "") enrolled successfully.")
                .font(.title2)
                .padding()

            AISecondaryButton(title: "End Session") {
                action(.openned)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
