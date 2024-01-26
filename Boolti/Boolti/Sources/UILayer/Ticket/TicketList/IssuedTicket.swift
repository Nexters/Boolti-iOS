//
//  IssuedTicket.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import UIKit

enum TicketType {
    case premium
    case invitation
}

struct IssuedTicket {
    let ticketType: TicketType
    let poster: UIImage
    let title: String
    let date: String
    let location: String
    let QRCode: UIImage
}
