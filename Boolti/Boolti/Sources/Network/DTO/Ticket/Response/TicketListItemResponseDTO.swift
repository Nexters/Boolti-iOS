//
//  TicketListItemResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/6/24.
//

import UIKit

struct TicketListItemResponseDTO: Decodable {

    let ticketId: Int
    let showName: String
    let placeName: String
    let showDate: String
    let showImgPath: String
    let ticketType: String
    let ticketName: String
    let entryCode: String
    let usedAt: String?
}

extension TicketListItemResponseDTO {

    func convertToTicketItemEntity() -> TicketItemEntity {
        /// 티켓 타입
        let ticketType = self.ticketType == "SALE" ? TicketType.sale : TicketType.invitation

        /// 티켓 이름
        let ticketName = self.ticketName

        /// 포스터 이미지
        // 여기서 KingFisher로 Image 가져오기 OR 혹은 url만 던지고 다른 곳에서 Image 가져오기!.. -> Data 영역에서 UIKit을 import하는 게 별로여서!...
        let posterImage: UIImage = .mockPoster

        /// 공연 이름
        let title = self.showName

        /// 공연 날짜
        // 추후에 Custom DateFormatter 타입을 정의할 예정
        let isoDateFormatter = DateFormatter()
        isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let date = isoDateFormatter.date(from: self.showDate) ?? Date()
        let formatterDate = date.format(.dateDay)
        

        /// 공연 장소
        let location = self.placeName

        /// QR 코드 이미지
        // 여기서 QR 코드 이미지로 변환할 예정
        let qrCodeImage: UIImage = .qrCode

        /// 티켓 ID
        let ticketID = self.ticketId

        /// 사용된 ticket
        let usedTime = self.usedAt


        return TicketItemEntity(
            ticketType: ticketType,
            ticketName: ticketName,
            poster: posterImage,
            title: title,
            date: formatterDate,
            location: location,
            qrCode: qrCodeImage,
            ticketID: ticketID,
            usedTime: usedTime
        )
    }
}