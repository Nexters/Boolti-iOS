//
//  ConcertDetailResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import Foundation

struct ConcertDetailResponseDTO: Codable {
    
    let id: Int
    let groupId: Int
    let name: String
    let placeName: String
    let date: String
    let runningTime: Int
    let streetAddress: String
    let detailAddress: String
    let latitude: Int?
    let longitude: Int?
    let notice: String
    let managerCode: String
    let salesStartTime: String
    let salesEndTime: String
    let deletedAt: String?
    let showImg: [ShowImg]
    let hostName: String
    let hostPhoneNumber: String
    
    struct ShowImg: Codable {
        let id: Int
        let showId: Int
        let path: String
        let thumbnailPath: String
        let sequence: Int
        let createdAt: String
        let modifiedAt: String?
        let removedAt: String?
    }

    func convertToConcertDetailEntity() -> ConcertDetailEntity {
        let posters = self.showImg.map { showImgDTO in
            return ConcertDetailEntity.Poster(
                id: showImgDTO.id,
                path: showImgDTO.path,
                thumbnailPath: showImgDTO.thumbnailPath,
                sequence: showImgDTO.sequence
            )
        }
        
        return ConcertDetailEntity(
            id: self.id,
            groupId: self.groupId,
            name: self.name,
            placeName: self.placeName,
            date: self.date.formatToDate(),
            runningTime: self.runningTime,
            streetAddress: self.streetAddress,
            detailAddress: self.detailAddress,
            notice: self.notice,
            salesStartTime: self.salesStartTime.formatToDate(),
            salesEndTime: self.salesEndTime.formatToDate(),
            posters: posters,
            hostName: self.hostName,
            hostPhoneNumber: self.hostPhoneNumber
        )
    }
}
