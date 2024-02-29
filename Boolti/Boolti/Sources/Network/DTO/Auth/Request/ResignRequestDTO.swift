//
//  ResignRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/22/24.
//

import Foundation

struct ResignRequestDTO: Encodable {
    let reason: String
    let appleIdAuthorizationCode: String?
}
