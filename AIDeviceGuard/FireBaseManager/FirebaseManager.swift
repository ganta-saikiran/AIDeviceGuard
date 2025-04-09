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
        print("📡 Starting to observe Firebase DB for device updates...")
        
        ref.observe(.value) { snapshot in
            print("🔍 Data snapshot received: \(snapshot)")
            
            var fetchedDevices: [Device] = []
            var index = 0
            
            for child in snapshot.children {
                index += 1
                if let snap = child as? DataSnapshot {
                    print("📦 Processing child \(index): key = \(snap.key)")
                    
                    if let dict = snap.value as? [String: Any] {
                        print("🧩 Raw dictionary: \(dict)")
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: dict)
                            let device = try JSONDecoder().decode(Device.self, from: jsonData)
                            fetchedDevices.append(device)
                            
                            print("✅ Device decoded successfully: \(device)")
                        } catch {
                            print("❌ Error decoding device at index \(index): \(error.localizedDescription)")
                        }
                    } else {
                        print("⚠️ Could not cast snapshot.value to [String: Any] for key: \(snap.key)")
                    }
                } else {
                    print("⚠️ Unexpected snapshot child type at index \(index)")
                }
            }
            
            DispatchQueue.main.async {
                print("📝 Updating published devices list with \(fetchedDevices.count) device(s)")
                self.devices = fetchedDevices
            }
        }
    }}
