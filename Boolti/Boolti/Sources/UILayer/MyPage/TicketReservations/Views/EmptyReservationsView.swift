//
//  EmptyReservationsStackView.swift
//  Boolti
//
//  Created by Miro on 2/10/24.
//

import UIKit

class EmptyReservationsStackView: UIStackView {

    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .headline1
        label.textColor = .grey05
        label.text = "예매 내역이 없어요"

        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .body3
        label.textColor = .grey30
        label.text = "티켓을 예매하고 공연을 즐겨보세요!"

        return label
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.axis = .vertical
        self.alignment = .center

        self.addArrangedSubviews([
            self.mainTitleLabel,
            self.subTitleLabel
        ])
    }
}
