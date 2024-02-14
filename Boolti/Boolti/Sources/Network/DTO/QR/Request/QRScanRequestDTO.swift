//
//  QRScanRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import Foundation

struct QRScanRequestDTO: Encodable {
    
    let showId: Int
    let entryCode: String
}
