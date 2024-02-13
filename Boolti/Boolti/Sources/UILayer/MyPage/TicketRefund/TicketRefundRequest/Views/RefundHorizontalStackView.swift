//
//  RefundHorizontalStackView.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

class RefundHorizontalStackView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .grey30

        return label
    }()

    private let contentTextField: BooltiTextField = {
        let textField = BooltiTextField()

        return textField
    }()

    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubviews([
            self.titleLabel,
            self.contentTextField
        ])

        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        let screenWidth = window.screen.bounds.width

        self.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
            make.height.equalTo(48)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.left.equalToSuperview().inset(20)
        }

        self.contentTextField.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.left.equalTo(self.titleLabel.snp.right)
        }
    }
}
