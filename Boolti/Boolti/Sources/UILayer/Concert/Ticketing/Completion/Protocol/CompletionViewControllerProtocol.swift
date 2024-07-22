//
//  CompletionViewControllerProtocol.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import UIKit

protocol CompletionViewControllerProtocol {
    associatedtype reservationEntity: ReservationDetailEntityProtocol

    func makeLabel(text: String?) -> BooltiUILabel
    func makeInfoRowStackView(title: BooltiUILabel, info: BooltiUILabel) -> UIStackView
    func makeInfoGroupStackView(with stackViews: [UIStackView]) -> UIStackView

    func configureSaleTicketCases(with entity: reservationEntity)
    func setAccountTransferPaymentTicketCase(with entity: reservationEntity)
    func setSimplePaymentTicketCase(with entity: reservationEntity)
    func setCardPaymentTicketCase(with entity: reservationEntity)
    func setFreeTicketCase(with entity: reservationEntity)
}

extension CompletionViewControllerProtocol {

    func makeLabel(text: String? = nil) -> BooltiUILabel {
        let label = BooltiUILabel()
        label.font = .pretendardR(16)
        label.text = text
        label.textColor = text == nil ? .grey15 : .grey30
        label.numberOfLines = 2
        return label
    }

    func makeInfoRowStackView(title: BooltiUILabel, info: BooltiUILabel) -> UIStackView {
        title.snp.makeConstraints { make in
            make.width.equalTo(100)
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.addArrangedSubviews([title, info])
        stackView.alignment = .top
        return stackView
    }

    func makeInfoGroupStackView(with stackViews: [UIStackView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubviews(stackViews)
        return stackView
    }

    func configureSaleTicketCases(with entity: reservationEntity) {
        guard let paymentMethod = entity.paymentMethod else { return }
        switch paymentMethod {
        case .accountTransfer:
            self.setAccountTransferPaymentTicketCase(with: entity)
        case .card:
            self.setCardPaymentTicketCase(with: entity)
        case .simplePayment:
            self.setSimplePaymentTicketCase(with: entity)
        case .free:
            self.setFreeTicketCase(with: entity)
        }
    }
}
