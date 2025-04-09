//
//  FirebaseManager.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 08/04/25.
//


import FirebaseDatabase
import Foundation
import Combine

class FirebaseManager: ObservableObject {
    private let ref = Database.database().reference().child("devices")
    @Published var devices: [Device] = []

    // 🟢 Write (User takes a device)

    func assignDevice(deviceId: String, deviceName: String, employeeName: String, deviceType: String = "IOS", status: String) {
        guard !deviceId.isEmpty,
                  !deviceId.contains(where: { ".#$[]".contains($0) }) else {
                print("❌ Firebase Error: Invalid deviceId: \(deviceId)")
                return
            }
        let now = Date().timeIntervalSince1970
        let deviceData: [String: Any] = [
            "assignedTo": [
                "name": employeeName,
                "enrollTime": String(Int(now)),
                "exitTime": "",
            ],
            "device_id": deviceId,
            "device_name": deviceName,
            "device_type": deviceType,
            "status": status
        ]
        
        let ref = Database.database().reference()
        ref.child("devices").child(deviceId).setValue(deviceData)
    }


    // 🔵 Read (List all devices)
    func fetchDevices() {
        ref.observe(.value) { snapshot in
            print("🔍 Data snapshot received: \(snapshot)")

            var fetchedDevices: [Device] = []

            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any],
                   let jsonData = try? JSONSerialization.data(withJSONObject: dict),
                   let device = try? JSONDecoder().decode(Device.self, from: jsonData) {
                    fetchedDevices.append(device)
                }
            }

            DispatchQueue.main.async {
                self.devices = fetchedDevices
            }
        }
    }

}
