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
    case ticketingDetail
    case ticketingCompletion
    case concertDetail
    case ticketDetail
}

final class BooltiNavigationBar: UIView {
    
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
        
        self.configureDefaultConstraints()
        
        switch type {
        case .ticketingDetail: self.configureTicketingDetailUI()
        case .ticketingCompletion: self.configureTicketingCompletionUI()
        case .concertDetail: self.configureConcertDetailUI()
        case .ticketDetail: self.configureTicketDetailUI()
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
            make.height.equalTo(88)
        }
    }
    
    private func configureTicketingDetailUI() {
        self.titleLabel.text = "결제하기"
        self.backgroundColor = .grey95
        
        self.addSubviews([self.backButton, self.titleLabel])
        self.configureTicketingDetailConstraints()
    }
    
    private func configureTicketingCompletionUI() {
        self.backgroundColor = .grey95
        
        self.addSubviews([self.homeButton, self.closeButton])
        self.configureTicketingCompletionConstraints()
    }
    
    private func configureConcertDetailUI() {
        self.backgroundColor = .grey90
        
        self.addSubviews([self.backButton, self.homeButton, self.shareButton, self.moreButton])
        self.configureConcertDetailConstraints()
    }

    private func configureTicketDetailUI() {
        self.backgroundColor = .grey95

        self.addSubview(self.backButton)
        self.configureTicketDetailConstraints()
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
            make.left.equalTo(self.backButton).offset(20)
            make.width.height.equalTo(24)
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
            make.left.equalTo(self.backButton.snp.right).offset(20)
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
