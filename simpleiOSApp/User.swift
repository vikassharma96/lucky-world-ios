//
//  User.swift
//  simpleiOSApp
//
//  Created by Ruby Kumari on 07/08/19.
//  Copyright © 2019 MIND. All rights reserved.
//

import Foundation

class User : Codable {
    var name : String
    var number : String
    var email : String
    var deviceId : String
    var deviceName : String
    var deviceLocation: String
    
    init(name: String, number: String, email: String, deviceId: String, deviceName: String, deviceLocation: String){
        self.name = name
        self.number = number
        self.email = email
        self.deviceId = deviceId
        self.deviceName = deviceName
        self.deviceLocation = deviceLocation
    }
}
