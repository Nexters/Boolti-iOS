//
//  DeviceTokenRegisterRequestDTO.swift
//  Boolti
//
//  Created by Miro on 2/27/24.
//

import Foundation

struct DeviceTokenRegisterRequestDTO: Encodable {

    let deviceToken: String
    let deviceType: String = "IOS"
}
