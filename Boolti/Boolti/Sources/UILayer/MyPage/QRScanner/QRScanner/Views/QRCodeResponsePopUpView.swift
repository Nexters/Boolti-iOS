//
//  QRCodeResponsePopUpView.swift
//  Boolti
//
//  Created by Miro on 2/26/24.
//

import UIKit

class QRCodeResponsePopUpView: UIView {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    private let responseDescriptionLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .white00

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with item: QRCodeValidationResponse) {
        self.iconImageView.image = item.iconImage
        self.responseDescriptionLabel.text = item.rawValue
    }

    private func configureUI() {
        self.backgroundColor = .grey85
        self.layer.cornerRadius = 4
        self.alpha = 0.8

        self.addSubviews([
            self.iconImageView,
            self.responseDescriptionLabel
        ])

        self.configureConstraints()

    }

    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.width.equalTo(335)
            make.height.equalTo(48)
        }

        self.iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }

        self.responseDescriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.iconImageView.snp.right).offset(12)
        }
    }
}
