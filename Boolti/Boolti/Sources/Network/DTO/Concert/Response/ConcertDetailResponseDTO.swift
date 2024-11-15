//
//  ConcertDetailResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import Foundation

struct ConcertDetailResponseDTO: Decodable {
    
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
    let reservationStatus: Bool
    let salesTicketCount: Int

    struct ShowImg: Decodable {
        let id: Int
        let showId: Int
        let path: String
        let thumbnailPath: String
        let sequence: Int
        let createdAt: String
        let modifiedAt: String?
        let removedAt: String?
    }

    func calculateTicketingState() -> ConcertTicketingState {
        let currentDate = Date() // Date()를 한 번만 호출
        let salesStartDate = self.salesStartTime.formatToDate()
        let salesEndDate = self.salesEndTime.formatToDate()
        let concertDate = self.date.formatToDate()

        if currentDate < salesStartDate {
            return .beforeSale(startDate: salesStartDate)
        } else if Calendar.current.isDate(currentDate, inSameDayAs: salesEndDate) {
            return .onSale(isLastDate: true)
        } else if currentDate < salesEndDate {
            return .onSale(isLastDate: false)
        } else if currentDate.getBetweenDay(to: concertDate) >= 0 {
            return .endSale
        } else {
            return .endConcert
        }
    }

//    func calculateTicketingState() -> ConcertTicketingState {
//        var state: ConcertTicketingState = .onSale(isLastDate: false)
//
//        if Date() < self.salesStartTime.formatToDate() {
//            state = .beforeSale(startDate: self.salesStartTime.formatToDate())
//        }
//        else if Date() == self.salesEndTime.formatToDate() {
//            state = .onSale(isLastDate: true)
//        }
//        else if Date() < self.salesEndTime.formatToDate() {
//            state = .onSale(isLastDate: false)
//        }
//        else if Date().getBetweenDay(to: self.date.formatToDate()) >= 0 {
//            state = .endSale
//        }
//        else {
//            state = .endConcert
//        }
//
//        return state
//    }

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
            hostPhoneNumber: self.hostPhoneNumber,
            reservationStatus: self.reservationStatus,
            salesTicketCount: self.salesTicketCount,
            ticketingState: self.calculateTicketingState()
        )
    }
}
