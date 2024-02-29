//
//  DepositInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit

final class DepositSummaryView: UIView {
    
    // MARK: UI Component
    
    private let datePriceLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.numberOfLines = 2
        label.font = .point4
        label.textColor = .grey05
        return label
    }()
    
    private let infoLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.numberOfLines = 2
        label.font = .body1
        label.textColor = .grey50
        label.text = "입금 마감일까지 입금이 확인되지 않는 경우\n주문이 자동 취소됩니다."
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
        view.addArrangedSubviews([self.datePriceLabel, self.infoLabel])
        return view
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

extension DepositSummaryView {
    
    func setData(date: Date, price: Int) {
        let formattedDate = date.format(.simple)
        let formattedPrice = "\(price.formattedCurrency())원"
        self.datePriceLabel.text = "\(formattedDate)까지 아래 계좌로\n\(formattedPrice)을 입금해주세요"
        self.datePriceLabel.setSubStringColor(to: [formattedDate, formattedPrice], with: .orange01)
    }
}

// MARK: - UI

extension DepositSummaryView {
    
    private func configureUI() {
        self.addSubviews([self.stackView])
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(160)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(20)
        }
    }
}
