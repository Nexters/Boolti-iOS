//
//  BooltiNavigationView.swift
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

final class BooltiNavigationView: UIView {
    
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
    
    // MARK: Init
    
    init(type: NavigationType) {
        super.init(frame: .zero)
        
        self.configureDefaultUI()
        
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

// MARK: - UI

extension BooltiNavigationView {
    
    private func makeButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .grey10
        return button
    }
    
    private func configureDefaultUI() {
        self.backgroundColor = .grey95
        
        self.configureDefaultConstraints()
    }
    
    private func configureDefaultConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(88)
        }
    }
    
    private func configureTicketingDetailUI() {
        self.addSubviews([self.backButton, self.titleLabel])
        
        self.configureBackButtonConstraints()
        self.configureTitleConstraints()
        
        self.titleLabel.text = "결제하기"
    }
    
    private func configureTicketingCompletionUI() {
        self.addSubviews([self.homeButton, self.closeButton])
        
        self.configureHomeButtonConstraints()
        self.configureCloseButtonConstraints()
    }
    
    private func configureConcertDetailUI() {
        self.addSubview(self.backButton)

        self.configureBackButtonConstraints()
    }

    private func configureTicketDetailUI() {
        self.addSubview(self.backButton)
        self.configureBackButtonConstraints()
    }

    private func configureBackButtonConstraints() {
        self.backButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(20)
            make.height.width.equalTo(24)
        }
    }
    
    private func configureHomeButtonConstraints() {
        self.homeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(20)
            make.height.width.equalTo(24)
        }
    }
    
    private func configureTitleConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.backButton.snp.right).offset(4)
            make.centerY.equalTo(self.backButton.snp.centerY)
        }
    }
    
    private func configureCloseButtonConstraints() {
        self.closeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(20)
            make.height.width.equalTo(24)
        }
    }
}

// MARK: - Methods

extension BooltiNavigationView {
    
    func didBackButtonTap() -> Signal<Void> {
        return backButton.rx.tap.asSignal()
    }
    
    func didHomeButtonTap() -> Signal<Void> {
        return homeButton.rx.tap.asSignal()
    }
    
    func didCloseButtonTap() -> Signal<Void> {
        return closeButton.rx.tap.asSignal()
    }
}
