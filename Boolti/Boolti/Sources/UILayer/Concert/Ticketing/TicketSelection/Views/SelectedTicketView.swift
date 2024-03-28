//
//  SelectedTicketView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit

import RxSwift

final class SelectedTicketView: UIView {

    // MARK: Properties

    private let disposeBag = DisposeBag()
    let cellHeight: CGFloat = 96

    // MARK: UI Component
    
    let selectedSalesTicketView = SelectedSalesTicketView()

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

extension SelectedTicketView {

    func setTotalPriceLabel(price: Int) {
        self.totalPriceLabel.text = "총 \(price.formattedCurrency())원"
    }

}

// MARK: - UI

extension SelectedTicketView {

    private func configureUI() {
        self.addSubviews([self.selectedSalesTicketView,
                          self.underlineView,
                          self.priceInfoLabel,
                          self.totalPriceLabel,
                          self.ticketingButton])
    }

    private func configureConstraints() {
        self.selectedSalesTicketView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.underlineView.snp.top)
            make.height.equalTo(114)
        }

        self.underlineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(self.totalPriceLabel.snp.top).offset(-18)
        }

        self.priceInfoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalTo(self.totalPriceLabel)
        }

        self.totalPriceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.bottom.equalTo(self.ticketingButton.snp.top).offset(-26)
        }

        self.ticketingButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
