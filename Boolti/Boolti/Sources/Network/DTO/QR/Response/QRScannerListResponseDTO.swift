//
//  QRScannerListResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import Foundation

struct QRScannerListResponseDTOElement: Decodable {
    let showId: Int
    let showName: String
    let date: String
    let runningTime: Int
    let managerCode: String
    let salesStartTime: String?
    let salesEndTime: String?
    let showImg: String?
}

typealias QRScannerListResponseDTO = [QRScannerListResponseDTOElement]

extension QRScannerListResponseDTO {
    
    func convertToQRScannerEntities() -> [QRScannerEntity] {
        return self.map { scanner in
            let concertEndDatetime = scanner.date.formatToDate().addingTimeInterval(TimeInterval(scanner.runningTime * 60))
            let isConcertEnd = concertEndDatetime < Date()
            
            return QRScannerEntity(concertId: scanner.showId,
                                   concertName: scanner.showName,
                                   isConcertEnd: isConcertEnd,
                                   entranceCode: scanner.managerCode)
        }
    }
}
