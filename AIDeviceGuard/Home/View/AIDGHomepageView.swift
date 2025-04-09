//
//  AIDGHomepageView.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 06/04/25.
//

import SwiftUI
import AIComponents
import FirebaseDatabase

struct AIDGHomepageView: View {
    @StateObject var viewModel: AIDGHomePageViewModel = AIDGHomePageViewModel()
    @StateObject private var manager = FirebaseManager()

    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    content
                        .navigationDestination(isPresented: $viewModel.showSuceesScreen) {
                            AIDGSuccessScreen(
                                action: { action in
                                    switch action {
                                    case .openned:
                                        viewModel.endSession()
                                        if !viewModel.isSessionActive {
                                            manager.assignDevice(
                                                deviceId: viewModel.deviceId,
                                                deviceName: viewModel.deviceName,
                                                employeeName: "",
                                                status: "AVAILABLE"
                                            )
                                        }
                                        viewModel.showSuceesScreen = false
                                        viewModel.isSessionActive = false
                                    case .closedd:
                                        break
                                    }
                                },
                                deviceName: viewModel.deviceName,
                                employeeName: viewModel.employeeName
                            )
                        }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
            } else {
                NavigationView {
                    content
                        .background(
                            NavigationLink(
                                destination: ActiveDevicesListView(),
                                isActive: $viewModel.navigateTOactivedevice
                            ) { EmptyView() }
                        )
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
            }
        }
        .onChange(of: viewModel.employeeName) { newValue in
            UserDefaults.standard.set(newValue, forKey: viewModel.employeeNameKey)
        }
        .onChange(of: viewModel.deviceName) { newValue in
            UserDefaults.standard.set(newValue, forKey: viewModel.deviceNameKey)
        }
        .fullScreenCover(item: $viewModel.presentedView) { screen in
            makeFullScreenViews(screen)
        }
        .onAppear {
            if let savedEmployeeName = UserDefaults.standard.string(forKey: viewModel.employeeNameKey) {
                viewModel.employeeName = savedEmployeeName
            }
            if let savedDeviceName = UserDefaults.standard.string(forKey: viewModel.deviceNameKey) {
                viewModel.deviceName = savedDeviceName
            }
            manager.fetchDevices()
        }
    }
}
extension AIDGHomepageView {
    @ViewBuilder var content: some View {
        ZStack {
            Image("AIAppBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(alignment: .center, spacing: 24) {
                Spacer()
                    .frame(height: 80)

                inputFields
                sessionButtonOrEmpty
                Spacer()
            }
            .padding(.top, 40)
            .padding(.horizontal,60)

            .toastView(message: viewModel.toastMessage, isVisible: $viewModel.showToast)
        }
    }

    @ViewBuilder var viewAllDevices: some View {
        Button(action: {
            viewModel.navigateTOactivedevice = true
        }) {
            HStack(spacing: 4) {
                Image(systemName: "list.bullet.rectangle")
                Text("View All Devices")
            }
            .font(.subheadline)
            .foregroundColor(.blue)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
    }

    @ViewBuilder var inputFields: some View {
        VStack(spacing: 16) {
            AIInputField(
                .constant(viewModel.employeeName),
                placeholder: "Employee Name",
                errorMessage: $viewModel.errorMessage,
                allowedCharacters: AIStringValidatorConstants.allowedName
            ) { _ in }
            .disabled(true)
            .onTapGesture {
                viewModel.selectFullScreenView(.employeeName)
            }

            AIInputField(
                .constant(viewModel.deviceName),
                placeholder: "Device Name",
                errorMessage: $viewModel.errorMessage,
                allowedCharacters: AIStringValidatorConstants.allowedName
            ) { _ in }
            .disabled(true)
            .onTapGesture {
                viewModel.selectFullScreenView(.deviceName)
            }

            AIInputField(
                $viewModel.pinCode,
                placeholder: "Pin",
                errorMessage: $viewModel.errorMessage,
                allowedCharacters: AIStringValidatorConstants.allowedNumber
            ) { _ in }
        }
        .disabled(viewModel.isSessionActive)
    }

    @ViewBuilder var sessionButtonOrEmpty: some View {
        if !viewModel.isSessionActive {
            AIPrimaryButton(title: "Start Session") {
                // Check if the selected device is already BUSY
                if let selectedDevice = manager.devices.first(where: { $0.deviceId == viewModel.deviceId }),
                   selectedDevice.status.uppercased() == "BUSY" {
                    // Show toast or alert here
                    viewModel.toastMessage = "Device is already taken"
                    viewModel.showToast = true
                } else {
                    viewModel.startSession()

                    if viewModel.isSessionActive {
                        manager.assignDevice(
                            deviceId: viewModel.deviceId,
                            deviceName: viewModel.deviceName,
                            employeeName: viewModel.employeeName,
                            status: "BUSY"
                        )
                        viewModel.showSuceesScreen = true
                    }
                }
            }

        }
        
    }

    

    @ViewBuilder
    func makeFullScreenViews(_ screen: AIDGselectFullScreen) -> some View {
        switch screen {
        case .employeeName:
            return AIDGSearchListView(
                title: "Select Employee",
                items: viewModel.validCredentials.map { $0.employeeName }
            ) { selected in
                viewModel.employeeName = selected
                viewModel.presentedView = nil
            }

        case .deviceName:
            return AIDGSearchListView(
                title: "Select Device",
                items: viewModel.devices.map { $0.deviceName }
            ) { selected in
                viewModel.deviceName = selected
                viewModel.deviceId = viewModel.devices.first(where: { $0.deviceName == selected })?.deviceId ?? ""
                viewModel.presentedView = nil
            }
        }
    }
}

extension View {
    func toastView(message: String, isVisible: Binding<Bool>) -> some View {
        self.overlay(
            Group {
                if isVisible.wrappedValue {
                    VStack {
                        Spacer()
                        Text(message)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(12)
                            .padding(.bottom, 40)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    withAnimation {
                                        isVisible.wrappedValue = false
                                    }
                                }
                            }
                    }
                    .animation(.easeInOut(duration: 0.3), value: isVisible.wrappedValue)
                }
            }
        )
    }
} 
