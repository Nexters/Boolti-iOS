//
//  SelectedSalesTicketView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/28/24.
//

import UIKit

import RxCocoa

final class SelectedSalesTicketView: UIView {
    
    // MARK: Properties
    
    private var maxBuyCount: Int = 10
    
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
    
    private lazy var countingButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .grey80
        stackView.layer.cornerRadius = 4
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 32
        
        stackView.addArrangedSubviews([self.minusButton,
                                       self.plusButton])
        return stackView
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
        label.font = .subhead2
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

extension SelectedSalesTicketView {
    
    func setData(entity: SelectedTicketEntity) {
        self.nameLabel.text = entity.ticketName
        self.inventoryLabel.text = "\(entity.quantity)매 남음"
        self.priceLabel.text = "\(entity.price.formattedCurrency())원"
        self.totalPriceLabel.text = "\((entity.price * entity.count).formattedCurrency())원"
        self.maxBuyCount = entity.quantity
        self.setCount(with: entity.count)
    }
    
    private func setCount(with count: Int) {
        self.countLabel.text = "\(count)"
        
        self.minusButton.isEnabled = count > 1
        self.plusButton.isEnabled = count < self.maxBuyCount
    }
    
    var didMinusButtonTap: ControlEvent<Void> {
        return self.minusButton.rx.tap
    }
    
    var didPlusButtonTap: ControlEvent<Void> {
        return self.plusButton.rx.tap
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
                          self.countingButtonStackView,
                          self.countLabel,
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
        
        self.inventoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.nameLabel.snp.centerY)
            make.left.equalTo(self.nameLabel.snp.right).offset(8)
            make.height.equalTo(26)
        }

        self.countingButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(16)
            make.left.equalTo(self.nameLabel)
        }
        
        self.countLabel.snp.makeConstraints { make in
            make.center.equalTo(self.countingButtonStackView)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.countingButtonStackView)
            make.right.equalToSuperview().inset(24)
        }
        
        self.deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.nameLabel.snp.centerY)
            make.right.equalToSuperview().inset(24)
        }
        
        self.underlineView.snp.makeConstraints { make in
            make.top.equalTo(self.countingButtonStackView.snp.bottom).offset(20)
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
