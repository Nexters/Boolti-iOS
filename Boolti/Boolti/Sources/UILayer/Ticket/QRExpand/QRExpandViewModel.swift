//
//  QRExpandViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import UIKit

final class QRExpandViewModel {
    
    // MARK: Properties

    struct Output {
        let indexPath: IndexPath
        let tickets: [TicketDetailInformation]
    }

    let output: Output

    // MARK: Init
    
    init(indexPath: IndexPath, tickets: [TicketDetailInformation]) {
        self.output = Output(indexPath: indexPath, tickets: tickets)
    }
}
