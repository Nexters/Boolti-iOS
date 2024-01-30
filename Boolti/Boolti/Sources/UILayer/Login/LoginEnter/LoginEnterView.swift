//
//  LoginEnterView.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import UIKit
import SnapKit

class LoginEnterView: UIView {

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 로그인하고 \n원하는 공원의 티켓을 \n구매해보세요!"
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = .headline1
        label.textColor = .grey05

        return label
    }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .popupBackground)

        return imageView
    }()


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

        self.addSubviews([
            self.backgroundImageView,
            self.headerTitleLabel,
            self.loginButton
        ])
        
        self.backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.headerTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.backgroundImageView)
            make.centerY.equalTo(self.backgroundImageView)
        }

        self.loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.backgroundImageView)
            make.top.equalTo(self.headerTitleLabel.snp.bottom).offset(41)
            make.width.equalTo(145)
            make.height.equalTo(50)
        }
    }
}
