//
//  SelectedSalesTicketView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/28/24.
//

import UIKit

import RxCocoa

final class SelectedSalesTicketView: UIView {
    
    // MARK: UI Component
    
    private let nameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .headline1
        label.textColor = .grey05
        return label
    }()
    
    private let inventoryLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel()
        label.font = .caption
        label.textColor = .grey40
        label.backgroundColor = .grey90
        label.clipsToBounds = true
        label.layer.cornerRadius = 13
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey05
        return label
    }()
    
    private let countLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body2
        label.textColor = .grey15
        return label
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(.minus.withTintColor(.grey70), for: .disabled)
        button.setImage(.minus.withTintColor(.grey15), for: .normal)
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(.plus.withTintColor(.grey70), for: .disabled)
        button.setImage(.plus.withTintColor(.grey15), for: .normal)
        return button
    }()
    
    private lazy var countingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .grey80
        stackView.layer.cornerRadius = 4
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        
        stackView.addArrangedSubviews([self.minusButton,
                                       self.countLabel,
                                       self.plusButton])
        return stackView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton.withTintColor(.grey50), for: .normal)
        return button
    }()
    
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

extension SelectedSalesTicketView {
    
    func setData(entity: SelectedTicketEntity) {
        self.nameLabel.text = entity.ticketName
        self.inventoryLabel.text = "\(entity.quantity)매 남음"
        self.priceLabel.text = "\(entity.price.formattedCurrency())원"
        self.inventoryLabel.isHidden = entity.ticketType == .invitation
        self.setCount(with: entity.count)
    }
    
    func setCount(with count: Int) {
        self.countLabel.text = "\(count)"
        
        self.minusButton.isEnabled = count > 1
        self.plusButton.isEnabled = count < 10
    }
    
    var didDeleteButtonTap: ControlEvent<Void> {
        return self.deleteButton.rx.tap
    }
}

// MARK: - UI

extension SelectedSalesTicketView {
    
    private func configureUI() {
        self.backgroundColor = .clear
        
        self.addSubviews([self.nameLabel,
                          self.inventoryLabel,
                          self.priceLabel,
                          self.countingStackView,
                          self.deleteButton])
    }
    
    private func configureConstraints() {
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(24)
        }
        
        self.inventoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.nameLabel.snp.centerY)
            make.left.equalTo(self.nameLabel.snp.right).offset(8)
            make.height.equalTo(26)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(16)
        }
        
        self.countingStackView.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(16)
            make.left.equalTo(self.nameLabel)
            make.height.equalTo(32)
        }
        
        self.deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.nameLabel.snp.centerY)
            make.right.equalToSuperview().inset(24)
        }
    }
}
