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
    var performedShow: [PerformedShowDTO]? { get }
    var sns: [LinkDTO]? { get }
    
    func convertToUserProfile() -> ProfileEntity

}

struct ConcertUserProfileResponseDTO: UserProfileResponseDTO {

    let nickname: String?
    let userCode: String?
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

struct LinkDTO: Decodable {
    let title: String
    let link: String
}

struct PerformedShowDTO: Decodable {
    let id: Int
    let name: String
    let date: String
    let thumbnailPath: String
}
