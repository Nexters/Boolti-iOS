//
//  SignUpResponseDTO.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

struct SignUpResponseDTO: Decodable {

    let accessToken: String?
    let refreshToken: String?
}
