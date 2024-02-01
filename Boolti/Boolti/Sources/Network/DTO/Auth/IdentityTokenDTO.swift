//
//  IdentityTokenDTO.swift
//  Boolti
//
//  Created by Miro on 2/2/24.
//

import SwiftJWT

struct IdentityTokenDTO: Claims {
    let sub: String
}
