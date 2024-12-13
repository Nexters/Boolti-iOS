//
//  TicketSalesTimeView.swift
//  Boolti
//
//  Created by Miro on 11/13/24.
//

import UIKit

final class TicketSalesTimeView: UIView {

    // MARK: UI Component

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey10
        label.font = .subhead2
        label.text = "티켓 판매"

        return label
    }()

    private let soldCountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .greyTicketIcon
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private lazy var soldCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubviews([
            self.soldCountImageView,
            self.soldCountLabel
        ])

        return stackView
    }()

    private let soldCountLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body3
        return label
    }()

    private let datetimeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body3
        label.numberOfLines = 0

        return label
    }()

    private let underLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .grey85

        return view
    }()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension TicketSalesTimeView {

    func setData(startDate: Date, endDate: Date, soldCount: Int, ticketingState: ConcertTicketingState) {
        self.datetimeLabel.text = "\(startDate.format(.dateDay)) - \(endDate.format(.dateDay))"

        switch ticketingState {
        case .endSale, .endConcert:
            self.soldCountLabel.text = "\(soldCount)매 판매 완료"
        default:
            self.soldCountStackView.isHidden = true
        }

        self.snp.makeConstraints { make in
            make.height.equalTo(106 + self.datetimeLabel.getLabelHeight() + self.soldCountLabel.getLabelHeight())
        }
    }
}

// MARK: - UI

extension TicketSalesTimeView {

    private func configureUI() {
        self.addSubviews([self.titleLabel, self.datetimeLabel, self.soldCountStackView, self.underLineView])
    }

    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.datetimeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.titleLabel)
        }

        self.soldCountImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }

        self.soldCountStackView.snp.makeConstraints { make in
            make.top.equalTo(self.datetimeLabel.snp.bottom).offset(4)
            make.left.equalTo(self.titleLabel)
        }

        self.underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(self.datetimeLabel)
        }
    }
}
