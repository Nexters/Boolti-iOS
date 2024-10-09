//
//  UserResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/12/24.
//

import Foundation

// TODO: DTO와 Entity 분리하기!
struct UserResponseDTO: UserProfileResponseDTO {

    let id: Int
    let nickname: String?
    let userCode: String?
    let email: String?
    let imgPath: String?
    let introduction: String?
    let link: [LinkEntity]?
}

struct LinkEntity: Codable, Equatable {
    let title: String
    let link: String
}
