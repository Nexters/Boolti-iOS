//
//  PopupEntity.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/15/25.
//

import Foundation

struct PopupEntity {

    let id: Int
    let type: PopupType
    let eventUrl: String?
    let view: PopupShowView
    let noticeTitle: String
    
    // in event case, emphasisDescription is image url
    let emphasisDescription: String?
    let description: String
    let startDate: Date
    let endDate: Date

}
