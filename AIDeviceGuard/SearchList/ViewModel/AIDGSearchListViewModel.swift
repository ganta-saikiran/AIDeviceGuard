//
//  AIDGSearchListViewModel.swift
//  AIDeviceGuard
//
//  Created by Ganta Saikiran on 07/04/25.
//

import Foundation
import UIKit
enum AIDGSearchType {
    case employee
    case device
}
class AIDGSearchListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var screenTitle: String = ""
    @Published var filteredEmployees: [Employee] = []
    @Published var filteredDevices: [Devices] = []
    @Published var locationImage: String = "locationSearch"



    let employees: [Employee] = [
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
            Devices(deviceName: "iphone 14", deviceId: "1")
            ,Devices(deviceName: "iphone 14 Plus", deviceId: "2")
            ,Devices(deviceName: "iphone 15", deviceId: "3"),Devices(deviceName: "iphone 15", deviceId: "4") ,Devices(deviceName: "iphone 15 Plus", deviceId: "5"),     Devices(deviceName: "iphone 15 Plus", deviceId: "6"),Devices(deviceName: "iphone 16", deviceId: "7")
        ]

     var searchType: AIDGSearchType?

    func setSearchType(_ type: AIDGSearchType) {
        self.searchType = type
        self.screenTitle = (type == .employee) ? "Select Employee" : "Select Device"
        filterContent()
    }

    func filterContent() {
        switch searchType {
        case .employee:
            filteredEmployees = employees.filter { employee in
                searchText.isEmpty || employee.employeeName.lowercased().contains(searchText.lowercased())
            }
        case .device:
            filteredDevices = devices.filter { device in
                searchText.isEmpty || device.deviceName.lowercased().contains(searchText.lowercased())
            }
        case .none:
            break
        }
    }
}
