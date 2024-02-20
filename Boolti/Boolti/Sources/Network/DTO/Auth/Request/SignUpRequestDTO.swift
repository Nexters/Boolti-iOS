//
//  SignUpRequestDTO.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

struct SignUpRequestDTO: Encodable {

    let nickname: String?
    let email: String?
    let phoneNumber: String?
    let oauthType: String
    let oauthIdentity: String
    let imgPath: String?
}
