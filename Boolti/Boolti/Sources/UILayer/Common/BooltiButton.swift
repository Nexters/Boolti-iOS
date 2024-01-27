//
//  BooltiButton.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import UIKit
import SnapKit

class BooltiButton: UIButton {

    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead1
        label.textColor = .white00
        return label
    }()

    init(title: String) {
        super.init(frame: .zero)
        self.configureUI(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(title: String) {
        self.addSubview(self.mainTitleLabel)

        self.mainTitleLabel.text = title
        self.layer.cornerRadius = 4
        self.backgroundColor = .orange01

        self.configureConstraints()
    }

    private func configureConstraints() {

        self.mainTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }

//        self.snp.makeConstraints { make in
//            make.width.equalTo(self.snp.height).multipliedBy(6)
//        }
    }
}

