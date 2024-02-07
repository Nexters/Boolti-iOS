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
    let date: Date
    let runningTime: Int
    let streetAddress: String
    let detailAddress: String
    let latitude: Int?
    let longitude: Int?
    let notice: String
    let managerCode: String
    let salesStartTime: Date
    let salesEndTime: Date
    let deletedAt: Date?
    let showImg: [ShowImg]
    
    struct ShowImg: Codable {
        let id: Int
        let showId: Int
        let path: String
        let thumbnailPath: String
        let sequence: Int
        let createdAt: Date
        let modifiedAt: Date?
        let removedAt: Date?
    }
    
    func mapToConcertDetailEntity() -> ConcertDetailEntity {
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
            date: self.date,
            runningTime: self.runningTime,
            streetAddress: self.streetAddress,
            detailAddress: self.detailAddress,
            notice: self.notice,
            salesStartTime: self.salesStartTime,
            salesEndTime: self.salesEndTime,
            posters: posters
        )
    }
}
