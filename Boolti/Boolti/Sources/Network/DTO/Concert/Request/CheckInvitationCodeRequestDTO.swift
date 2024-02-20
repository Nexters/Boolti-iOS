//
//  CheckInvitationCodeRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/12/24.
//

import Foundation

struct CheckInvitationCodeRequestDTO: Encodable {
    
    let showId: Int
    let salesTicketTypeId: Int
    let inviteCode: String
}
