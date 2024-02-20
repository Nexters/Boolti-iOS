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
        case invalid = "유효하지 않은 QR 입니다"
        case notToday = "입장 확인은 공연 당일에만 가능해요"
        
        var textColor: UIColor {
            switch self {
            case .valid, .notToday: .grey10
            case .invalid: .error
            }
        }
    }
    
    private let disposeBag = DisposeBag()
    private let qrRepository: QRRepositoryType
    
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
    
    init(qrRepository: QRRepositoryType,
         qrScannerEntity: QRScannerEntity) {
        self.input = Input()
        self.output = Output()
        self.qrRepository = qrRepository
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
        self.qrRepository.qrScan(concertId: self.qrScannerEntity.concertId,
                                 entranceCode: detectedCode)
        .subscribe(with: self, onSuccess: { owner, isValid in
            owner.output.showCheckLabel.accept(.valid)
        }, onFailure: { owner, error in
            if error.localizedDescription.contains("428") {
                owner.output.showCheckLabel.accept(.notToday)
            } else {
                owner.output.showCheckLabel.accept(.invalid)
            }
        })
        .disposed(by: self.disposeBag)
    }
}
