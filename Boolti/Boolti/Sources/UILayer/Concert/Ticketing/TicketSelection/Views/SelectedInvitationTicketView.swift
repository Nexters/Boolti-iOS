//
//  SelectedInvitationTicketView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/28/24.
//

import UIKit

import RxCocoa

final class SelectedInvitationTicketView: UIView {
    
    // MARK: UI Component
    
    private let nameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .headline1
        label.textColor = .grey05
        return label
    }()
    
    private let priceLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey05
        label.text = "0원"
        return label
    }()
    
    private let onePerPersonLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey15
        label.text = "1인 1매"
        return label
    }()
    
    private let countLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body2
        label.textColor = .grey15
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton.withTintColor(.grey50), for: .normal)
        return button
    }()
    
    private let underlineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .grey80
        return view
    }()

    private let priceInfoLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey30
        label.text = "총 결제 금액"
        return label
    }()

    private let totalPriceLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body4
        label.textColor = .orange01
        return label
    }()

    let ticketingButton = BooltiButton(title: "예매하기")
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension SelectedInvitationTicketView {
    
    func setData(entity: SelectedTicketEntity) {
        self.nameLabel.text = entity.ticketName
        self.priceLabel.text = "\(entity.price.formattedCurrency())원"
        self.totalPriceLabel.text = "\((entity.price * entity.count).formattedCurrency())원"
    }
    
    var didDeleteButtonTap: ControlEvent<Void> {
        return self.deleteButton.rx.tap
    }
}

// MARK: - UI

extension SelectedInvitationTicketView {
    
    private func configureUI() {
        self.backgroundColor = .clear
        
        self.addSubviews([self.nameLabel,
                          self.onePerPersonLabel,
                          self.priceLabel,
                          self.deleteButton,
                          self.underlineView,
                          self.priceInfoLabel,
                          self.totalPriceLabel,
                          self.ticketingButton])
    }
    
    private func configureConstraints() {
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(24)
        }
        
        self.onePerPersonLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(16)
            make.left.equalTo(self.nameLabel)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.deleteButton.snp.bottom).offset(17)
            make.right.equalToSuperview().inset(24)
        }
        
        self.deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.nameLabel.snp.centerY)
            make.right.equalToSuperview().inset(24)
        }
        
        self.underlineView.snp.makeConstraints { make in
            make.top.equalTo(self.priceLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }

        self.priceInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.underlineView.snp.bottom).offset(17)
            make.left.equalToSuperview().inset(24)
        }

        self.totalPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.priceInfoLabel)
            make.right.equalToSuperview().inset(24)
        }

        self.ticketingButton.snp.makeConstraints { make in
            make.top.equalTo(self.priceInfoLabel.snp.bottom).offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
