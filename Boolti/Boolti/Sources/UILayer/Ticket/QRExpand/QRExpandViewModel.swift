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
        let qrCodeImage: UIImage
        let ticketName: String
    }

    let output: Output

    // MARK: Init
    
    init(qrCodeImage: UIImage, ticketName: String) {
        self.output = Output(qrCodeImage: qrCodeImage, ticketName: ticketName)
    }
}
