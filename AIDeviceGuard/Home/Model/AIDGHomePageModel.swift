//
//  AIDGHomePageModel.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 07/04/25.
//

//import Foundation
//
//struct Devices {
//    var deviceName : String
//    var deviceId : String
//}
//struct Employee {
//    var employeeName : String
//    var pin : String
//}
//enum AIDGselectFullScreen: Int, Identifiable {
//    var id: Int { rawValue }
//    case employeeName
//    case deviceName
//}

struct Devices: Identifiable {
    var id: String { deviceId }
    let deviceName: String
    let deviceId: String
}

struct Employee {
    let employeeName: String
    let pin: String
}

//enum AIDGselectFullScreen: Identifiable {
//    var id: String {
//        switch self {
//        case .employeeName: return "employeeName"
//        case .deviceName: return "deviceName"
//        }
//    }
//
//    case employeeName
//    case deviceName
//}
//
