//
//  DeviceDetails.swift
//  simpleiOSApp
//
//  Created by Ruby Kumari on 13/08/19.
//  Copyright © 2019 MIND. All rights reserved.
//

import Foundation

class DeviceDetails : Codable {
    var deviceMac : String
    var deviceName : String
    var deviceLocation: String
    
    init(deviceMac: String, deviceName: String, deviceLocation: String){
        self.deviceMac = deviceMac
        self.deviceName = deviceName
        self.deviceLocation = deviceLocation
    }
}
