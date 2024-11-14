//
//  UserResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/12/24.
//

import Foundation

struct UserResponseDTO: UserProfileResponseDTO {
    let id: Int
    let nickname: String?
    let userCode: String?
    let email: String?
    let imgPath: String?
    let introduction: String?
    let link: [LinkDTO]?
    let performedShow: [PerformedShowDTO]?
    let sns: [LinkDTO]?
    
    func convertToUserProfile() -> ProfileEntity {
        let links = self.link?.map { DTO in
            return LinkEntity(title: DTO.title,
                              link: DTO.link)
        }
        
        let snses = self.sns?.map { DTO in
            return SnsEntity(snsType: SNSType(rawValue: DTO.title) ?? .instagram ,
                             name: DTO.link)
        }
        
        let performedConcerts = self.performedShow?.map { DTO in
            return PerformedConcertEntity(id: DTO.id,
                                          name: DTO.name,
                                          date: DTO.date,
                                          thumbnailPath: DTO.thumbnailPath)
        }
        
        return .init(profileImageURL: self.imgPath ?? "",
                     nickname: self.nickname ?? "",
                     introduction: self.introduction ?? "",
                     links: links ?? [],
                     performedConcerts: performedConcerts ?? [],
                     snses: snses ?? [])
    }

}
