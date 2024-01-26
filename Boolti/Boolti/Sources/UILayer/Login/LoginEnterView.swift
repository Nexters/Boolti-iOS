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

        label.text = "지금 로그인하고 원하는 공원의 티켓을 구매해보세요!"
        return label
    }()

    let loginButton: UIButton = {
        let button = UIButton()

        button.setTitle("로그인 하러가기", for: .normal)
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
        self.addSubview(headerTitleLabel)
        self.addSubview(loginButton)

        self.headerTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(100)
        }

        self.loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.headerTitleLabel.snp.bottom).offset(50)
        }
    }
    

    
}
