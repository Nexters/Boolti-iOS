//
//  InvitationTicketingRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/12/24.
//

import Foundation

struct InvitationTicketingRequestDTO: Encodable {
    
    let userId: Int
    let showId: Int
    let salesTicketTypeId: Int
    let reservationName: String
    let reservationPhoneNumber: String
    let inviteCode: String
}
