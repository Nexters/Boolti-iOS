//
//  ProfileEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/7/24.
//

struct ProfileEntity {
    let profileImageURL: String
    let nickname: String
    let introduction: String
    var links: [LinkEntity]
    var performedConcerts: [PerformedConcertEntity]
    var snses: [SnsEntity]
}

struct SnsEntity: Codable, Equatable {
    let snsType: SNSType
    let name: String
}

struct LinkEntity: Codable, Equatable {
    let title: String
    let link: String
}

struct PerformedConcertEntity {
    let id: Int
    let name: String
    let date: String
    let thumbnailPath: String
}
