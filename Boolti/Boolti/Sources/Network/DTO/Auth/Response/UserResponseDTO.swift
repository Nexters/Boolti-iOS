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
    let performedShow: [ConcertListResponseDTOElement]?
    let sns: [SNSDTO]?
    
    func convertToUserProfile() -> ProfileEntity {
        let links = self.link?.map { DTO in
            return LinkEntity(title: DTO.title,
                              link: DTO.link)
        }
        
        let snses = self.sns?.map { DTO in
            return SnsEntity(snsType: SNSType(rawValue: DTO.type) ?? .instagram ,
                             name: DTO.username)
        }
        
        let performedConcerts = self.performedShow?.map { DTO in
            return ConcertEntity(id: DTO.id,
                                 name: DTO.name,
                                 dateTime: DTO.date.formatToDate(),
                                 salesStartTime: DTO.salesStartTime.formatToDate(),
                                 salesEndTime: DTO.salesEndTime.formatToDate(),
                                 posterPath: DTO.showImg ?? "")
        }
        
        return .init(profileImageURL: self.imgPath ?? "",
                     nickname: self.nickname ?? "",
                     introduction: self.introduction ?? "",
                     links: links ?? [],
                     performedConcerts: performedConcerts ?? [],
                     snses: snses ?? [])
    }

}
