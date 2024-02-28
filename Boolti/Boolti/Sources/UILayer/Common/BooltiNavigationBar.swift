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
    case backButton
    case backButtonWithTitle(title: String)
    case titleWithCloseButton(title: String)
    case concertDetail
    case ticketingCompletion
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
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
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
        case .backButton: self.configureBackButtonUI()
        case .backButtonWithTitle(let title): self.configureBackButtonWithTitleUI(title)
        case .titleWithCloseButton(let title): self.configureTitleWithCloseButtonUI(title)
        case .concertDetail: self.configureConcertDetailUI()
        case .ticketingCompletion: self.configureTicketingCompletionUI()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension BooltiNavigationBar {
    
    func setBackgroundColor(with color: UIColor) {
        self.backgroundColor = color
    }
    
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

    private func configureBackButtonUI() {
        self.addSubview(self.backButton)
        
        self.backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func configureBackButtonWithTitleUI(_ title: String) {
        self.titleLabel.text = title

        self.addSubviews([self.backButton, self.titleLabel])
        
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
    
    private func configureTitleWithCloseButtonUI(_ title: String) {
        self.titleLabel.text = title
        
        self.addSubviews([self.titleLabel, self.closeButton])
        
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
    
    private func configureConcertDetailUI() {
        self.backgroundColor = .grey90

        self.addSubviews([self.backButton, self.homeButton, self.shareButton, self.moreButton])
        
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
    
    private func configureTicketingCompletionUI() {
        self.addSubviews([self.homeButton, self.closeButton])
        
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
