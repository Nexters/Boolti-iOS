//
//  UserResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/12/24.
//

import Foundation

struct UserResponseDTO: Decodable {

    let id: Int
    let nickname: String?
    let userCode: String?
    let email: String?
    let imgPath: String?
    let introduction: String?
    let link: [LinkEntity]?
    
}

struct LinkEntity: Decodable {
    let title: String
    let link: String
}
