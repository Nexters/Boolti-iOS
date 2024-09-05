//
//  BooltiInputStackView.swift
//  Boolti
//
//  Created by Miro on 9/6/24.
//

import UIKit

final class BooltiInputStackView: UIStackView {

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey30

        return label
    }()
    private let textField: BooltiTextField

    init(title: String, textField: BooltiTextField) {
        self.textField = textField
        self.titleLabel.text = title
        
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.axis = .horizontal
        self.spacing = 12

        self.addArrangedSubviews([self.titleLabel, self.textField])

        self.configureConstraints()
    }

    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.width.equalTo(64)
        }
    }
}

