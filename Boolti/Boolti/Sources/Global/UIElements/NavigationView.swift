//
//  NavigationView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit
import RxCocoa
import SnapKit

final class NavigationView: UIView {
    
    enum NavigationType {
        case payment
        case concertDetail
    }
    
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
        
        self.setDefaultUI()
        
        switch type {
        case .payment: self.setPaymentUI()
        case .concertDetail: self.setConcertDetailUI()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI

extension NavigationView {
    
    private func setDefaultUI() {
        self.backgroundColor = .grey95
        
        self.snp.makeConstraints { make in
            make.height.equalTo(88)
        }
    }
    
    private func setPaymentUI() {
        self.setBackButtonLayout()
        self.setTitleLayout()
        
        self.titleLabel.text = "결제하기"
    }
    
    private func setConcertDetailUI() {
        self.setBackButtonLayout()
    }
    
    private func setBackButtonLayout() {
        self.addSubview(backButton)

        self.backButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(20)
            make.height.width.equalTo(24)
        }
    }
    
    private func setTitleLayout() {
        self.addSubview(titleLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.backButton.snp.right).offset(4)
            make.centerY.equalTo(self.backButton.snp.centerY)
        }
    }
}

// MARK: - Methods

extension NavigationView {
    
    func backButtonDidTap() -> Signal<Void> {
        return backButton.rx.tap.asSignal()
    }
}
