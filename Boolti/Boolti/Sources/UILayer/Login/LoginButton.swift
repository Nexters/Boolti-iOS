//
//  LoginButton.swift
//  Boolti
//
//  Created by Miro on 1/24/24.
//

import UIKit
import SnapKit

class LoginButton: UIButton {

    let logoIconImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()

    let startTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead1
        return label
    }()

    init(image: UIImage?, title: String, color: UIColor) {
        super.init(frame: .zero)
        self.configureUI(image: image, title: title, color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(image: UIImage?, title: String, color: UIColor) {
        self.addSubview(self.logoIconImageView)
        self.addSubview(self.startTitleLabel)

        self.logoIconImageView.image = image
        self.startTitleLabel.text = title
        self.backgroundColor = color

        self.logoIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.size.height.equalTo(20)
            make.size.width.equalTo(20)
        }

        self.startTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        self.layer.cornerRadius = 4
    }

}
