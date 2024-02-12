//
//  CheckInvitationCodeResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/12/24.
//

import Foundation

struct CheckInvitationCodeResponseDTO: Decodable {
    
    let id: Int
    let code: String
    let isUsed: Bool
    
    func convertToInvitationCodeEntity() -> InvitationCodeStateEntity {
        if isUsed {
            return InvitationCodeStateEntity(codeState: .used)
        } else {
            return InvitationCodeStateEntity(codeState: .verified)
        }
    }
}
