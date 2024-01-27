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
        button.setImage(.closeButton, for: .normal)
        button.tintColor = .grey50
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
    
    func setData(entity: TicketEntity) {
        self.nameLabel.text = entity.name
        self.inventoryLabel.text = "\(entity.inventory)매 남음"
        self.priceLabel.text = "\(entity.price)원"
        
        if entity.name == "초청 티켓" {
            self.inventoryLabel.isHidden = true
        }
    }
    
    var didDeleteButtonTap: ControlEvent<Void> {
        return self.deleteButton.rx.tap
    }
}

// MARK: - UI

extension SelectedTicketTableViewCell {
    
    private func configureUI() {
        self.backgroundColor = .clear
        
        self.contentView.addSubviews([nameLabel, inventoryLabel, priceLabel, deleteButton])
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
