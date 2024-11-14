//
//  EditProfileRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/5/24.
//

struct EditProfileRequestDTO: Encodable {
    let nickname: String
    let profileImagePath: String
    let introduction: String
    let link: [LinkDTO]
    let sns: [LinkDTO]
}
