//
//  ReversalPolicyConfirmButton.swift
//  Boolti
//
//  Created by Miro on 3/25/24.
//

import UIKit

class ReversalPolicyConfirmButton: UIButton {

    override var isSelected: Bool {
        didSet {
            self.updateUI()
        }
    }

    private let confirmeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.text = "취소/환불 규정을 확인했습니다"
        label.textColor = .grey10

        return label
    }()

    private let checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .checkboxOff
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {

        self.addSubviews([self.checkBoxImageView, self.confirmeLabel])

        self.backgroundColor = .grey85
        self.layer.borderColor = UIColor.grey80.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4

        self.configureConstraints()
    }

    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        self.checkBoxImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
        }

        self.confirmeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.checkBoxImageView.snp.right).offset(8)
        }
    }

    private func updateUI() {
        if self.isSelected {
            self.checkBoxImageView.image = .checkboxOn
        } else {
            self.checkBoxImageView.image = .checkboxOff
        }
    }

}
