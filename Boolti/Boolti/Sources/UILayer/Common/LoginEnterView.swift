//
//  LoginEnterView.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import UIKit

import SnapKit

class LoginEnterView: UIView {

    private let headerTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .headline1
        label.text = "지금 로그인하고\n원하는 공연의 티켓을\n예매해 보세요!"
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .grey05

        return label
    }()

    private let topBackgroundImageView = UIImageView(image: .popupBackground)

    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인 하러가기", for: .normal)
        button.titleLabel?.font = .subhead1
        button.titleLabel?.textColor = .grey05
        button.layer.cornerRadius = 4
        button.backgroundColor = .orange01

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.backgroundColor = .grey95

        self.addSubviews([
            self.topBackgroundImageView,
            self.headerTitleLabel,
            self.loginButton
        ])
        
        self.topBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(570)
        }

        self.headerTitleLabel.snp.makeConstraints { make in
            make.center.equalTo(self.topBackgroundImageView)
        }

        self.loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.topBackgroundImageView)
            make.top.equalTo(self.headerTitleLabel.snp.bottom).offset(28)
            make.width.equalTo(141)
            make.height.equalTo(48)
        }
    }
}
