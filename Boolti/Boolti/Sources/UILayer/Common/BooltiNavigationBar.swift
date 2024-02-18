//
//  BooltiNavigationBar.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit

import RxCocoa
import SnapKit

enum NavigationType {
    case defaultUI(backButtonTitle: String)
    case ticketingDetail
    case ticketingCompletion
    case concertDetail
    case ticketDetail
    case concertContentExpand
    case ticketReservations
    case report
    case ticketReservationDetail
    case qrScannerList
    case qrScanner(concertName: String)
}

final class BooltiNavigationBar: UIView {
    
    // MARK: Properties
    
    var statusBarHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.statusBarManager?.statusBarFrame.height ?? 44
        }
        return 44
    }
    
    // MARK: UI Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead2
        label.textColor = .grey10
        return label
    }()
    
    private lazy var backButton = self.makeButton(image: .back)
    
    private lazy var homeButton = self.makeButton(image: .home)
    
    private lazy var closeButton = self.makeButton(image: .closeButton)
    
    private lazy var shareButton = self.makeButton(image: .share)
    
    private lazy var moreButton = self.makeButton(image: .more)
    
    // MARK: Init
    
    init(type: NavigationType) {
        super.init(frame: .zero)
        
        self.backgroundColor = .grey95
        self.configureDefaultConstraints()
        
        switch type {
        case .defaultUI(let title): self.configureDefaultUI(title)
        case .ticketingDetail: self.configureTicketingDetailUI()
        case .ticketingCompletion: self.configureTicketingCompletionUI()
        case .concertDetail: self.configureConcertDetailUI()
        case .ticketDetail: self.configureTicketDetailUI()
        case .concertContentExpand: self.configureConcertContentExpandUI()
        case .ticketReservations: self.configureTicketReservationsUI()
        case .report: self.configureReportUI()
        case .ticketReservationDetail: self.configureTicketReservationDetailUI()
        case .qrScannerList: self.configureQRScannerListUI()
        case .qrScanner(let concertName): self.configureQRScannerUI(title: concertName)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension BooltiNavigationBar {
    
    private func makeButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .grey10
        return button
    }
}

// MARK: - UI

extension BooltiNavigationBar {
    
    private func configureDefaultConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.statusBarHeight + 44)
        }
    }

    private func configureDefaultUI(_ title: String) {
        self.titleLabel.text = title
        self.backgroundColor = .grey95

        self.addSubviews([self.backButton, self.titleLabel])
        self.configureTicketingDetailConstraints()
    }

    private func configureTicketingDetailUI() {
        self.titleLabel.text = "결제하기"
        
        self.addSubviews([self.backButton, self.titleLabel])
        self.configureTicketingDetailConstraints()
    }
    
    private func configureTicketingCompletionUI() {
        self.addSubviews([self.homeButton, self.closeButton])
        self.configureTicketingCompletionConstraints()
    }
    
    private func configureConcertDetailUI() {
        self.backgroundColor = .grey90

        self.addSubviews([self.backButton, self.homeButton, self.shareButton, self.moreButton])
        self.configureConcertDetailConstraints()
    }

    private func configureTicketDetailUI() {
        self.addSubview(self.backButton)
        self.configureTicketDetailConstraints()
    }
    
    private func configureConcertContentExpandUI() {
        self.titleLabel.text = "공연 내용"
        
        self.addSubviews([self.backButton, self.titleLabel])
        self.configureConcertContentExpandConstraints()
    }

    private func configureTicketReservationsUI() {
        self.titleLabel.text = "예매 내역"

        self.addSubviews([self.titleLabel, self.backButton])
        self.configureConcertContentExpandConstraints()
    }
    
    private func configureReportUI() {
        self.titleLabel.text = "신고하기"

        self.addSubviews([self.titleLabel, self.backButton])
        self.configureConcertContentExpandConstraints()
    }

    private func configureTicketReservationDetailUI() {
        self.titleLabel.text = "예매 내역 상세"

        self.addSubviews([self.titleLabel, self.backButton])
        self.configureConcertContentExpandConstraints()
    }
    
    private func configureQRScannerListUI() {
        self.titleLabel.text = "QR 스캔"

        self.addSubviews([self.titleLabel, self.backButton])
        self.configureConcertContentExpandConstraints()
    }
    
    private func configureQRScannerUI(title: String) {
        self.titleLabel.text = title
        self.titleLabel.clipsToBounds = true

        self.addSubviews([self.titleLabel, self.closeButton])
        self.configureQRScannerConstraints()
    }

    private func configureTicketDetailConstraints() {
        self.backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
        }
    }

    private func configureTicketingDetailConstraints() {
        self.backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.backButton.snp.right).offset(4)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func configureTicketingCompletionConstraints() {
        self.homeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
        }
        
    }
    
    private func configureConcertDetailConstraints() {
        self.backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
        }
        
        self.homeButton.snp.makeConstraints { make in
            make.left.equalTo(self.backButton.snp.right).offset(24)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
        }
        
        self.moreButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
        }
        
        self.shareButton.snp.makeConstraints { make in
            make.right.equalTo(self.moreButton.snp.left).offset(-20)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func configureConcertContentExpandConstraints() {
        self.backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.backButton.snp.right).offset(4)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func configureQRScannerConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.right.equalTo(self.closeButton.snp.left).offset(-20)
            make.bottom.equalToSuperview().inset(10)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
            
        }
    }
}

// MARK: - Methods

extension BooltiNavigationBar {
    
    func didBackButtonTap() -> Signal<Void> {
        return backButton.rx.tap.asSignal()
    }
    
    func didHomeButtonTap() -> Signal<Void> {
        return homeButton.rx.tap.asSignal()
    }
    
    func didCloseButtonTap() -> Signal<Void> {
        return closeButton.rx.tap.asSignal()
    }
    
    func didShareButtonTap() -> Signal<Void> {
        return shareButton.rx.tap.asSignal()
    }
    
    func didMoreButtonTap() -> Signal<Void> {
        return moreButton.rx.tap.asSignal()
    }
}
