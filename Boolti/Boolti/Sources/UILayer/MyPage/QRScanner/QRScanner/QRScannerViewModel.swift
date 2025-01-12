//
//  QRScannerViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

import UIKit

import Moya
import RxSwift
import RxRelay

enum QRCodeValidationResponse: String {
    case valid = "입장을 확인했어요"
    case invalid = "이 공연의 티켓이 아니에요"
    case isAlreadyUsed = "이미 입장에 사용된 티켓이에요"
    case notToday = "아직 공연일이 아니에요"

    init?(statusCode: Int) {
        switch statusCode {
        case 200:
            self = .valid
        case 428:
            self = .notToday
        case 400:
            self = .isAlreadyUsed
        default:
            self = .invalid
        }
    }

    var iconImage: UIImage {
        switch self {
        case .valid:
            return .validIcon
        case .invalid, .isAlreadyUsed:
            return .invalidIcon
        case .notToday:
            return .notTodayIcon
        }
    }
    
    var statusColor: UIColor {
        switch self {
        case .valid:
            return .success
        case .invalid, .isAlreadyUsed:
            return .error
        case .notToday:
            return .warning
        }
    }
}

final class QRScannerViewModel {
    
    // MARK: Properties

    private let disposeBag = DisposeBag()
    private let qrRepository: QRRepositoryType
    
    struct Input {
        let detectQRCode = PublishRelay<String>()
    }
    
    struct Output {
        let qrCodeValidationResponse = PublishRelay<QRCodeValidationResponse>()
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
            owner.output.qrCodeValidationResponse.accept(.valid)
        }, onFailure: { owner, error in
            guard let error = error as? MoyaError else { return }
            guard let statusCode = error.response?.statusCode else { return }
            guard let errorResponse = QRCodeValidationResponse(statusCode: statusCode) else { return }

            owner.output.qrCodeValidationResponse.accept(errorResponse)
        })
        .disposed(by: self.disposeBag)
    }
}
