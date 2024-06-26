//
//  TicketTypeTableViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class TicketTypeTableViewCell: UITableViewCell {

    let disposeBag = DisposeBag()

    // MARK: UI Component

    private let nameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .pretendardB(16)
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
 
    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        self.resetCell()
    }
}

// MARK: - Methods

extension TicketTypeTableViewCell {

    func setData(entity: SelectedTicketEntity) {
        self.nameLabel.text = entity.ticketName
        self.inventoryLabel.text = "\(entity.quantity)매 남음"

        if entity.quantity == 0 {
            self.nameLabel.textColor = .grey70
            self.priceLabel.textColor = .grey70
            self.priceLabel.text = "품절"
            self.inventoryLabel.isHidden = true
        } else {
            self.priceLabel.text = "\(entity.price.formattedCurrency())원"
        }

        if entity.ticketType == .invitation {
            self.inventoryLabel.isHidden = true
        }
    }
    
    func resetCell() {
        self.nameLabel.text = nil
        self.nameLabel.textColor = .grey05
        
        self.priceLabel.text = nil
        self.priceLabel.textColor = .grey05
        
        self.inventoryLabel.text = nil
        self.inventoryLabel.isHidden = false
    }
}

// MARK: - UI

extension TicketTypeTableViewCell {

    private func configureUI() {
        self.backgroundColor = .clear

        self.contentView.addSubviews([nameLabel, inventoryLabel, priceLabel])
    }

    private func configureConstraints() {
        self.nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(24)
        }

        self.inventoryLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.nameLabel.snp.right).offset(8)
            make.height.equalTo(24)
        }

        self.priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
        }
    }
}
