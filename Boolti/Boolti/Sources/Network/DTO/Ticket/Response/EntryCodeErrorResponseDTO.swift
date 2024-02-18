//
//  EntryCodeErrorResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/19/24.
//

import Foundation


struct EntryCodeErrorResponseDTO: Decodable {
    let type: String
    let showName: String
    let errorTraceId: String
    let detail: String
}

extension EntryCodeErrorResponseDTO {
    func convertToEntryCodeErrorResponseEntity() -> EntryCodeErrorEntity {
        var entryCodeResponse: EntryCodeResponse

        if self.type == "SHOW_NOT_TODAY" {
            entryCodeResponse = .notToday
        } else {
            entryCodeResponse = .mismatch
        }

        return EntryCodeErrorEntity(type: entryCodeResponse)
    }

}
