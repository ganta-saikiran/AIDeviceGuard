//
//  AIDGHomePageViewModel.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 06/04/25.
//


import Foundation
enum AIDGHomePageAction{
    case closedd
    case openned
}
enum AIDGselectFullScreen: Identifiable {
    case employeeName
    case deviceName

    var id: String {
        switch self {
        case .employeeName: return "employeeName"
        case .deviceName: return "deviceName"
        }
    }
}

enum AIDGHomepageSections: String, CaseIterable {
    case enroll
    case listDevices
    var rawValue: String {
        switch self {
        case .enroll:
            return "Enroll the Device"
        case .listDevices:
            return "View Devices"
        }
    }
}

class AIDGHomePageViewModel: ObservableObject {

    @Published var employeeName: String = ""
    @Published var deviceName: String = ""
    @Published var pinCode: String = ""
    @Published var deviceId: String = ""
    @Published var errorMessage : String = ""
    @Published var isSessionActive : Bool = false
    @Published var navigateTOactivedevice = false
    @Published var sessionStartTime: Date?
    @Published var showFullScreenCover: Bool = false
    @Published var presentedView: AIDGselectFullScreen?
    @Published var showSuceesScreen = false
    @Published var toastMessage = ""
    @Published var showToast = false
    @Published var tabselected: AIDGHomepageSections = .enroll

    // Include validCredentials and devices appropriately

    private let sessionStartKey = "sessionStartTime"
    private let isSessionActiveKey = "isSessionActive"
    let employeeNameKey = "employeeNameKey"
    let deviceNameKey = "deviceNameKey"


    let validCredentials: [Employee] = [
            Employee(employeeName: "Anusha C", pin: "1234"),
            Employee(employeeName: "Paul Abraham", pin: "5678"),
            Employee(employeeName: "Venugopal C B", pin: "9101"),
            Employee(employeeName: "Paul Jose", pin: "1121"),
            Employee(employeeName: "Vinod BR", pin: "3141"),
            Employee(employeeName: "Yethin Dias", pin: "5161"),
            Employee(employeeName: "Jenson Jacob", pin: "7181"),
            Employee(employeeName: "Vishnu PK", pin: "9202"),
            Employee(employeeName: "Nimith Thomas", pin: "1222"),
            Employee(employeeName: "Akhil Soman", pin: "3242"),
            Employee(employeeName: "Ashwathi R", pin: "5262"),
            Employee(employeeName: "Shefrin Hakeem", pin: "7282"),
            Employee(employeeName: "Anandu P", pin: "9303"),
            Employee(employeeName: "Suby Sukumaran", pin: "1333"),
            Employee(employeeName: "Sivaprasad K M", pin: "3353"),
            Employee(employeeName: "Thasni R", pin: "5373"),
            Employee(employeeName: "Ashwin Au", pin: "7393"),
            Employee(employeeName: "Rounak Kiran", pin: "9414"),
            Employee(employeeName: "Vipin Kuttikkara", pin: "1434"),
            Employee(employeeName: "Refaz Soofi", pin: "3454"),
            Employee(employeeName: "Linta George", pin: "5474"),
            Employee(employeeName: "Febin Paul", pin: "7494"),
            Employee(employeeName: "Neethu Varkey", pin: "9515"),
            Employee(employeeName: "Arun A", pin: "1535"),
            Employee(employeeName: "Jebin Ignatious", pin: "3555"),
            Employee(employeeName: "Karthick Cr", pin: "5575"),
            Employee(employeeName: "Lijin B", pin: "7595"),
            Employee(employeeName: "Bincy Baby", pin: "9616"),
            Employee(employeeName: "Ribin Haridas", pin: "1636"),
            Employee(employeeName: "Midhun R S", pin: "3656"),
            Employee(employeeName: "Gokuldas Ramdas", pin: "5676"),
            Employee(employeeName: "Bimya Chandroth", pin: "7696"),
            Employee(employeeName: "Anirudh Vinod", pin: "9717"),
            Employee(employeeName: "Annu Jo", pin: "1737"),
            Employee(employeeName: "Ganta Saikiran", pin: "3757"),
            Employee(employeeName: "Kashan Akram", pin: "5777"),
            Employee(employeeName: "Niranjana Ms", pin: "7797"),
            Employee(employeeName: "Paritosh Pathak", pin: "9818"),
            Employee(employeeName: "Riddhishwar S", pin: "1838"),
            Employee(employeeName: "Ajins Joy", pin: "3858"),
            Employee(employeeName: "Rasmi Krishnan", pin: "5878"),
            Employee(employeeName: "Renjit Peter", pin: "7898")
        ]
        let devices:[Devices] =  [
            Devices(deviceName: "iphone 14", deviceId: "i1")
            ,Devices(deviceName: "iphone 14 Plus", deviceId: "i2")
            ,Devices(deviceName: "iphone 15", deviceId: "i3"),Devices(deviceName: "iphone 15", deviceId: "i4") ,Devices(deviceName: "iphone 15 Plus", deviceId: "i5"),     Devices(deviceName: "iphone 15 Plus", deviceId: "i6"),Devices(deviceName: "iphone 16", deviceId: "i7")
        ]

    init() {
        checkExistingSession()
    }

    func startSession() {
        guard !employeeName.isEmpty, !deviceName.isEmpty, !pinCode.isEmpty else {
            toastMessage = "Please fill all fields"
            showToast = true
            return
        }

        let isValid = validCredentials.contains {
            $0.employeeName.lowercased() == employeeName.lowercased() &&
            $0.pin == pinCode
        }

        if isValid {
            let now = Date()
            UserDefaults.standard.set(now, forKey: sessionStartKey)
            UserDefaults.standard.set(true, forKey: isSessionActiveKey)
            isSessionActive = true
        } else {
            toastMessage = "Incorrect Name or Pin"
            showToast = true
        }
    }

    func endSession() {
        UserDefaults.standard.removeObject(forKey: sessionStartKey)
        UserDefaults.standard.set(false, forKey: isSessionActiveKey)
        isSessionActive = false
    }

    private func checkExistingSession() {
        let isActive = UserDefaults.standard.bool(forKey: isSessionActiveKey)
        isSessionActive = isActive

        if isActive, let _ = UserDefaults.standard.object(forKey: sessionStartKey) as? Date {
        //
        }
    }

    func selectFullScreenView(_ screen: AIDGselectFullScreen? = nil) {
        self.presentedView = screen
    }

    func formatTime(_ time: TimeInterval) -> String {
        let totalSeconds = Int(time)
        let days = totalSeconds / (24 * 3600)
        let hours = (totalSeconds % (24 * 3600)) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        if days > 0 {
            return String(format: "%02dd %02dh %02dm %02ds", days, hours, minutes, seconds)
        } else if hours > 0 {
            return String(format: "%02dh %02dm %02ds", hours, minutes, seconds)
        } else {
            return String(format: "%02dm %02ds", minutes, seconds)
        }
    }
    func getTabs() -> [AIDGHomepageSections] {
        return [AIDGHomepageSections.enroll, AIDGHomepageSections.listDevices]
        }
}
