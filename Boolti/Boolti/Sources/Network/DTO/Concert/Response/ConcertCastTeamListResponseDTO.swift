//
//  ConcertCastTeamListResponseDTO.swift
//  Boolti
//
//  Created by Miro on 10/6/24.
//

import Foundation

struct ConcertCastTeamListResponseDTO: Decodable {
    let id: Int
    let name: String
    let members: [TeamMemberDTO]
    let createdAt: String
    let modifiedAt: String

    func convertToTeamListEntity() -> ConcertCastTeamListEntity {
        let members = self.members.map { DTO in
            return TeamMember(
                id: DTO.id,
                code: DTO.userCode,
                imagePath: DTO.userImgPath,
                nickName: DTO.userNickname,
                roleName: DTO.roleName,
                createdAt: DTO.createdAt,
                modifiedAt: DTO.modifiedAt
            )
        }
        return ConcertCastTeamListEntity(
            id: self.id,
            name: self.name,
            members: members,
            createdAt: self.createdAt,
            modifiedAt: self.modifiedAt
        )
    }
}

struct TeamMemberDTO: Codable {
    let id: Int
    let userCode: String
    let userImgPath: String
    let userNickname: String
    let roleName: String
    let createdAt: String
    let modifiedAt: String
}
