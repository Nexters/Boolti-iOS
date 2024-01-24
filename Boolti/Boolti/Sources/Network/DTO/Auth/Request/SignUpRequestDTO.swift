//
//  SignUpRequestDTO.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

struct SignUpRequestDTO: Encodable {

    let name: String?
    let nickname: String?
    let email: String?
    let phoneNumber: String?
    let OAuthType: String
    let OAuthIdentity: String
    let imgPath: String?
}
