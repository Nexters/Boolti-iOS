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
<<<<<<<< HEAD:Boolti/Boolti/Sources/UILayer/Ticket/TicketSelection/Components/Cell/TicketTypeTableViewCell.swift
    
========

>>>>>>>> feature/#23-TicketsList:Boolti/Boolti/Sources/UILayer/Ticket/TicketSelection/Components/Cells/TicketTypeTableViewCell.swift
    // MARK: Properties

    let disposeBag = DisposeBag()

    // MARK: UI Component

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .body3
        label.textColor = .grey30
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
<<<<<<<< HEAD:Boolti/Boolti/Sources/UILayer/Ticket/TicketSelection/Components/Cell/TicketTypeTableViewCell.swift
 
    // MARK: Init
    
========

    // MARK: Init

>>>>>>>> feature/#23-TicketsList:Boolti/Boolti/Sources/UILayer/Ticket/TicketSelection/Components/Cells/TicketTypeTableViewCell.swift
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

extension TicketTypeTableViewCell {
<<<<<<<< HEAD:Boolti/Boolti/Sources/UILayer/Ticket/TicketSelection/Components/Cell/TicketTypeTableViewCell.swift
    
========

>>>>>>>> feature/#23-TicketsList:Boolti/Boolti/Sources/UILayer/Ticket/TicketSelection/Components/Cells/TicketTypeTableViewCell.swift
    func setData(entity: TicketEntity) {
        self.nameLabel.text = entity.name
        self.inventoryLabel.text = "\(entity.inventory)매 남음"

        if entity.inventory == 0 {
            self.nameLabel.textColor = .grey70
            self.priceLabel.textColor = .grey70
            self.priceLabel.text = "품절"
            self.inventoryLabel.isHidden = true
        } else {
            self.priceLabel.text = "\(entity.price.formattedCurrency())원"
        }

        if entity.name == "초청 티켓" {
            self.inventoryLabel.isHidden = true
        }
    }
}

// MARK: - UI

extension TicketTypeTableViewCell {
<<<<<<<< HEAD:Boolti/Boolti/Sources/UILayer/Ticket/TicketSelection/Components/Cell/TicketTypeTableViewCell.swift
    
========

>>>>>>>> feature/#23-TicketsList:Boolti/Boolti/Sources/UILayer/Ticket/TicketSelection/Components/Cells/TicketTypeTableViewCell.swift
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
            make.height.equalTo(26)
        }

        self.priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
        }
    }
}
