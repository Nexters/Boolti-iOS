//
//  TokenRefreshResponseDTO.swift
//  Boolti
//
//  Created by Miro on 1/31/24.
//

import Foundation

struct TokenRefreshResponseDTO: Decodable {

    let accessToken: String?
    let refreshToken: String?
}
