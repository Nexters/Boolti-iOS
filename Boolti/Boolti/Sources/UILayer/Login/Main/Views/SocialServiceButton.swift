//
//  SocialServiceButton.swift
//  Boolti
//
//  Created by Miro on 6/26/24.
//

import UIKit

enum SocialProvider {
    case kakao
    case apple
}

class SocialServiceButton: UIButton {
    private var buttonConfiguration = UIButton.Configuration.plain()
    private let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(title: String, type: SocialProvider) {
        super.init(frame: .zero)
        self.configureUI(title: title, type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(title: String, type: SocialProvider) {
        self.buttonConfiguration.title = title
        self.buttonConfiguration.attributedTitle?.font = .subhead1
        self.buttonConfiguration.baseForegroundColor = .black100
        self.buttonConfiguration.imagePadding = 20
        self.configureUI(by: type)
        self.configuration = self.buttonConfiguration

        self.layer.cornerRadius = 12
        self.addSubview(self.logoImageView)
        self.configureConstraints()
    }

    private func configureUI(by type: SocialProvider) {
        switch type {
        case .kakao:
            self.buttonConfiguration.background.backgroundColor = UIColor.init("#FFE833")
            self.logoImageView.image = .kakao
        case .apple:
            self.buttonConfiguration.background.backgroundColor = UIColor.init("#F6F7FF")
            self.logoImageView.image = .apple
        }
    }

    private func configureConstraints() {
        self.logoImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
    }
}
