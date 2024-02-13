//
//  QRScannerViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

import UIKit

import RxSwift
import RxRelay

final class QRScannerViewModel {
    
    // MARK: Properties
    
    enum entranceCodeState: String {
        case valid = "입장을 확인했어요"
        case invalid = "확인이 필요합니다"
        
        var textColor: UIColor {
            switch self {
            case .valid: .grey10
            case .invalid: .error
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let detectQRCode = PublishRelay<String>()
    }
    
    struct Output {
        let showCheckLabel = PublishRelay<entranceCodeState>()
    }
    
    let input: Input
    let output: Output
    
    let qrScannerEntity: QRScannerEntity
    
    // MARK: Init
    
    init(qrScannerEntity: QRScannerEntity) {
        self.input = Input()
        self.output = Output()
        
        self.qrScannerEntity = qrScannerEntity
        self.bindInputs()
    }
}

// MARK: - Methods

extension QRScannerViewModel {
    
    private func bindInputs() {
        self.input.detectQRCode
            .bind(with: self) { owner, detectedCode in
                owner.entranceCodeCheck(detectedCode: detectedCode)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension QRScannerViewModel {
    
    private func entranceCodeCheck(detectedCode: String) {
        self.output.showCheckLabel.accept(.invalid)
    }
}
