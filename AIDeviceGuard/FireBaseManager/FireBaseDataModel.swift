//
//  FireBaseDataModel.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 08/04/25.
//

import Foundation

struct AssignedTo: Codable {
    var name: String
    var enrollTime: String
    var exitTime: String?
}

struct Device: Codable, Identifiable {
    var id: String { deviceId } // for Identifiable conformance
    var deviceId: String
    var device_name: String
    var status: String
    var device_type: String? 
    var assignedTo: AssignedTo
    enum CodingKeys: String, CodingKey {
            case deviceId = "device_id"
            case device_name
            case status
            case device_type
            case assignedTo
        }
}
