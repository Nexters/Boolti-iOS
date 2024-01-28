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
    case payment
    case concertDetail
}

final class BooltiNavigationView: UIView {
    
    // MARK: UI Component
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead2
        label.textColor = .grey10
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.back, for: .normal)
        return button
    }()
    
    // MARK: Init
    
    init(type: NavigationType) {
        super.init(frame: .zero)
        
        self.configureDefaultUI()
        
        switch type {
        case .payment: self.configurePaymentUI()
        case .concertDetail: self.configureConcertDetailUI()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI

extension BooltiNavigationView {
    
    private func configureDefaultUI() {
        self.backgroundColor = .grey95
        
        self.addSubview(backButton)
        
        self.configureDefaultConstraints()
    }
    
    private func configureDefaultConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(88)
        }
    }
    
    private func configurePaymentUI() {
        self.addSubview(backButton)
        self.addSubview(titleLabel)
        
        self.configureBackButtonConstraints()
        self.configureTitleConstraints()
        
        self.titleLabel.text = "결제하기"
    }
    
    private func configureConcertDetailUI() {
        self.addSubview(backButton)
        
        self.configureBackButtonConstraints()
    }
    
    private func configureBackButtonConstraints() {
        self.backButton.snp.makeConstraints { make in
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
}

// MARK: - Methods

extension BooltiNavigationView {
    
    func backButtonDidTapped() -> Signal<Void> {
        return backButton.rx.tap.asSignal()
    }
}
