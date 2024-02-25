//
//  TicketRefundBankCollectionViewCell.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

final class TicketRefundBankCollectionViewCell: UICollectionViewCell {
    
    private let bankImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let bankNameLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .grey15

        return label
    }()

    override var isSelected: Bool {
        didSet {
            self.updateSelectionUI()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.bankImageView.image = nil
        self.bankNameLabel.text = nil
        self.layer.borderWidth = 0
        self.contentView.alpha = 1.0
    }
    
    private func configureUI() {
        self.layer.cornerRadius = 4
        self.backgroundColor = .grey80

        self.contentView.addSubviews([
            self.bankImageView,
            self.bankNameLabel
        ])
    }

    func setData(with entity: BankEntity) {
        self.bankImageView.image = entity.bankIconImage
        self.bankNameLabel.text = entity.bankName
    }
    
    private func updateSelectionUI() {
        self.layer.borderColor = self.isSelected ? UIColor.grey10.cgColor : nil
        self.layer.borderWidth = self.isSelected ? 1.0 : 0
        self.contentView.alpha = self.isSelected ? 1.0 : 0.4
    }

    private func configureConstraints() {
        self.bankImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }

        self.bankNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
