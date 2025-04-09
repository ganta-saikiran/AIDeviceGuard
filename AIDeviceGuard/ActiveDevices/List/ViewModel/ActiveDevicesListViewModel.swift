//
//  ActiveDevicesListViewModel.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 06/04/25.
//

import Foundation
import Combine

class ActiveDevicesListViewModel: ObservableObject {
    @Published var devices: [Device] = []

    private var firebaseManager = FirebaseManager()
    private var cancellables = Set<AnyCancellable>()

    func fetchDevices() {
        firebaseManager.fetchDevices()
        
        firebaseManager.$devices
            .sink { [weak self] fetchedDevices in
                self?.devices = fetchedDevices
            }
            .store(in: &cancellables)
    }
}
