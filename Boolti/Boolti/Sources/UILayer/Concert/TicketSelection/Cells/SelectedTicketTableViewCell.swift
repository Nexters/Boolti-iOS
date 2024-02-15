//
//  SelectedTicketTableViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class SelectedTicketTableViewCell: UITableViewCell {

    // MARK: Properties

    let disposeBag = DisposeBag()

    // MARK: UI Component

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline1
        label.textColor = .grey05
        return label
    }()

    private let inventoryLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel()
        label.font = .caption
        label.textColor = .grey40
        label.backgroundColor = .grey80
        label.clipsToBounds = true
        label.layer.cornerRadius = 13
        label.textAlignment = .center
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .body3
        label.textColor = .grey15
        return label
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton.withTintColor(.grey50), for: .normal)
        return button
    }()

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension SelectedTicketTableViewCell {

    func setData(entity: SelectedTicketEntity) {
        self.nameLabel.text = entity.ticketName
        self.inventoryLabel.text = "\(entity.quantity)매 남음"
        self.priceLabel.text = "\(entity.price.formattedCurrency())원"
        self.inventoryLabel.isHidden = entity.ticketType == .invite
    }

    var didDeleteButtonTap: ControlEvent<Void> {
        return self.deleteButton.rx.tap
    }
}

// MARK: - UI

extension SelectedTicketTableViewCell {

    private func configureUI() {
        self.backgroundColor = .clear

        self.contentView.addSubviews([self.nameLabel,
                                      self.inventoryLabel,
                                      self.priceLabel,
                                      self.deleteButton])
    }

    private func configureConstraints() {
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(24)
            make.width.lessThanOrEqualTo(self.frame.width * 0.7)
        }

        self.inventoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.nameLabel.snp.centerY)
            make.left.equalTo(self.nameLabel.snp.right).offset(8)
            make.height.equalTo(26)
        }

        self.priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(16)
        }

        self.deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
        }
    }
}
