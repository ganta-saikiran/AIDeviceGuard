//
//  ActiveDevicesListView.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 06/04/25.
//
import SwiftUI
import AIComponents

struct ActiveDevicesListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ActiveDevicesListViewModel()

    var body: some View {
        ZStack {
            // 🔹 Background
            Image("AIAppBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 0) {
        
                // 🔹 Device List
                if viewModel.devices.isEmpty {
                    Spacer()
                    Text("No Active Devices Found")
                        .font(.headline)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.devices) { device in
                            HStack {
                                Image(systemName: "iphone.gen2")
                                    .foregroundColor(.blue)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(device.device_name)
                                        .font(.headline)

                                    Text("Employee: \(device.assignedTo.name.isEmpty ? "None" : device.assignedTo.name)")
                                        .font(.subheadline)

                                    Text("Status: \(device.status)")
                                        .font(.subheadline)
                                        .foregroundColor(device.status.lowercased() == "available" ? .green : .red)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(.horizontal, 20)
        }
        .onAppear(){
            viewModel.fetchDevices()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
