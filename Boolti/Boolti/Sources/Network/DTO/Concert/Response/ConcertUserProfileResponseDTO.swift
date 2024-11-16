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
    var link: [LinkDTO]? { get }
    var performedShow: [ConcertListResponseDTOElement]? { get }
    var sns: [SNSDTO]? { get }
    
    func convertToUserProfile() -> ProfileEntity

}

struct ConcertUserProfileResponseDTO: UserProfileResponseDTO {

    let nickname: String?
    let userCode: String?
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

struct LinkDTO: Codable {
    let title: String
    let link: String
}

struct SNSDTO: Codable {
    let type: String
    let username: String
}
