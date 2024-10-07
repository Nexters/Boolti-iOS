//
//  ConcertUserProfileResponseDTO.swift
//  Boolti
//
//  Created by Miro on 10/8/24.
//

import Foundation

protocol UserProfileResponseDTO: Decodable {
    var nickname: String? { get }
    var userCode: String? { get }
    var imgPath: String? { get }
    var introduction: String? { get }
    var link: [LinkEntity]? { get }
}

struct ConcertUserProfileResponseDTO: UserProfileResponseDTO {

    let nickname: String?
    let userCode: String?
    let imgPath: String?
    let introduction: String?
    let link: [LinkEntity]?
}
