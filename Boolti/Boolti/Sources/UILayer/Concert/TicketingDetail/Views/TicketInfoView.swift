//
//  TicketInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit

final class TicketInfoView: UIView {
    
    // MARK: UI Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "티켓 정보"
        label.font = .subhead2
        label.textColor = .grey10
        return label
    }()
    
    private lazy var ticketTypeTitleLabel = self.makeSelectedTitleLabel(title: "티켓 종류")
    private lazy var ticketTypeDataLabel = self.makeSelectedDataLabel()
    private lazy var ticketTypeStackView = self.makeStackView(with: [ticketTypeTitleLabel, ticketTypeDataLabel])
    
    private lazy var ticketCountTitleLabel = self.makeSelectedTitleLabel(title: "티켓 매수")
    private lazy var ticketCountDataLabel = self.makeSelectedDataLabel()
    private lazy var ticketCountStackView = self.makeStackView(with: [ticketCountTitleLabel, ticketCountDataLabel])
    
    private lazy var totalPriceTitleLabel = self.makeSelectedTitleLabel(title: "총 결제 금액")
    private lazy var totalPriceDataLabel = self.makeSelectedDataLabel()
    private lazy var totalPriceStackView = self.makeStackView(with: [totalPriceTitleLabel, totalPriceDataLabel])
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 20
        
        view.addArrangedSubviews([self.ticketTypeStackView, self.ticketCountStackView, self.totalPriceStackView])
        return view
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
        
        self.setData(entity: .init(id: 1, concertId: 1, ticketType: .sales, ticketName: "일반 티켓 A", price: 5000, quantity: 100))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension TicketInfoView {
    
    func setData(entity: SelectedTicketEntity) {
        self.ticketTypeDataLabel.text = entity.ticketName
        self.ticketCountDataLabel.text = "1개"
        self.totalPriceDataLabel.text = "\(entity.price.formattedCurrency())원"
    }
}

// MARK: - UI

extension TicketInfoView {
    
    private func makeSelectedTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.font = .body3
        label.text = title
        label.textColor = .grey30
        return label
    }
    
    private func makeSelectedDataLabel() -> UILabel {
        let label = UILabel()
        label.font = .body3
        label.textColor = .grey15
        label.textAlignment = .right
        return label
    }
    
    private func makeStackView(with: [UILabel]) -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.addArrangedSubviews(with)
        return view
    }
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.stackView])
        
        self.backgroundColor = .grey90
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(198)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(28)
        }
    }
}