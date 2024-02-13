//
//  TicketRefundBankCollectionViewCell.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

class TicketRefundBankCollectionViewCell: UICollectionViewCell {
    
    private let bankImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .nong
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let bankNameLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .grey15
        label.text = "카카오뱅크"

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.layer.cornerRadius = 4
        self.backgroundColor = .grey80

        self.contentView.addSubviews([
            self.bankImageView,
            self.bankNameLabel
        ])
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
