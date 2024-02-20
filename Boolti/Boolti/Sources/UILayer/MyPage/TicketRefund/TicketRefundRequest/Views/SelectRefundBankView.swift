//
//  SelectRefundBankView.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

final class SelectRefundBankView: UIView {

    let bankNameLabel: UILabel = {
        let label = UILabel()
        label.font = .body3
        label.text = "은행 선택"
        label.textColor = .grey15

        return label
    }()

    private let viewCollapseIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronDown

        return imageView
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with bankName: String) {
        self.bankNameLabel.text = bankName
    }

    private func configureUI() {
        self.backgroundColor = .grey85

        self.addSubviews([
            self.bankNameLabel,
            self.viewCollapseIconImageView
        ])

        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        self.bankNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
        }

        self.viewCollapseIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
        }
    }

}
