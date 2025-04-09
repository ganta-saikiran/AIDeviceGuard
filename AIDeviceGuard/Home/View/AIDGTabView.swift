//
//  AIDGTab.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 09/04/25.
//


import SwiftUI
import AIComponents

enum AIDGTab {
    case home, devices
}

struct AIDGHomepageTabView: View {
    @ObservedObject var viewModel: AIDGHomePageViewModel = AIDGHomePageViewModel()
    @ObservedObject private var manager = FirebaseManager()

    var body: some View {
        VStack(spacing: 0) {
            headerView
            // Top Tab Bar
            AIPrimarySegmentControl(
                selectedItem: $viewModel.tabselected,
                            dataSource: viewModel.getTabs(),
                            itemTitle: { item in
                                item.rawValue
                            })
                        VStack {
                            makeListView()
                        }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
                
    }


extension AIDGHomepageTabView{
    @ViewBuilder var headerView: some View {
        VStack(spacing: 0) {
            Image("AirIndiaLogo")
                .resizable()
                .frame(width: 160, height: 60)
            AIText(text: "AICODI-DeviceGuard", font: .AIFonts.AIText22Bold, color: .black, alignment: .center)
        }
    }
    
    func makeListView() -> some View {
            // loadView()
            TabView(
                selection: $viewModel.tabselected,
                content: {
               if viewModel.isSessionActive {
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
                    } else {
                        AIDGHomepageView()
                            .tag(AIDGHomepageSections.enroll)
                    }

                    
                    ActiveDevicesListView()
                        .tag(AIDGHomepageSections.listDevices)
                })
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
}
