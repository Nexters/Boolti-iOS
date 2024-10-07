//
//  ConcertCastTeamListEntity.swift
//  Boolti
//
//  Created by Miro on 10/6/24.
//

import Foundation

struct ConcertCastTeamListEntity {
    let id: Int
    let name: String
    let members: [TeamMember]
    let createdAt: String
    let modifiedAt: String
}

struct TeamMember {
    let id: Int
    let code: String
    let imagePath: String
    let nickName: String
    let roleName: String
    let createdAt: String
    let modifiedAt: String
}
