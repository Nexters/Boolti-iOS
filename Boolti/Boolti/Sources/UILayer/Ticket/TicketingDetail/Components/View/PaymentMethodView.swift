//
//  PaymentMethodView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit
import RxSwift

final class PaymentMethodView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "결제 수단"
        label.font = .subhead2
        label.textColor = .grey10
        return label
    }()
    
    private let depositButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0)
        config.title = "계좌 이체"
        config.attributedTitle?.font = .body3
        config.baseForegroundColor = .grey15
        config.background.backgroundColor = .grey85
        
        let button = UIButton(configuration: config)

        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.grey80.cgColor
        
        return button
    }()
    
    private let infoIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.info
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 페이지에서 계좌 번호를 안내해 드릴게요"
        label.font = .body1
        label.textColor = .grey40
        return label
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
        self.bindEvents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension PaymentMethodView {
    
    private func bindEvents() {
        self.depositButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                debugPrint("계좌 이체 선택")
            }).disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension PaymentMethodView {
    
    private func configureUI() {
        self.addSubviews([titleLabel, depositButton, infoIcon, infoLabel])
        
        self.backgroundColor = .grey90
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(166)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        self.depositButton.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        self.infoIcon.snp.makeConstraints { make in
            make.top.equalTo(self.depositButton.snp.bottom).offset(14)
            make.left.equalTo(self.depositButton)
            make.height.width.equalTo(20)
        }
        
        self.infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.infoIcon)
            make.left.equalTo(self.infoIcon.snp.right).offset(6)
        }
    }
}
