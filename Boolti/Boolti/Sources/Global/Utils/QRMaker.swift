//
//  QRMaker.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import UIKit
import CoreImage.CIFilterBuiltins

final class QRMaker {
    
    static var shared = QRMaker()

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    private let encoder = JSONEncoder()

    func makeQR(identifier: String) -> UIImage? {

        guard let qrData = identifier.data(using: .utf8) else {
            return UIImage().withTintColor(.grey30)
        }

        self.filter.setValue(qrData, forKey: "inputMessage")

        if let qrCodeImage = self.filter.outputImage {
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            let scaledCIImage = qrCodeImage.transformed(by: transform)
            if let qrCodeCGImage = self.context.createCGImage(scaledCIImage, from: scaledCIImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }

        return UIImage().withTintColor(.grey30)
    }
}
