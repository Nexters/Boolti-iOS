//
//  LoginResponseDTO.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

struct LoginResponseDTO: Decodable {

    let signUpRequired: Bool
    let accessToken: String?
    let refreshToken: String?
}