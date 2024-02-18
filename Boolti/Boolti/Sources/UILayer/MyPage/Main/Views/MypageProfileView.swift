//
//  MypageProfileView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/17/24.
//

import UIKit

final class MypageProfileView: UIView {
    
    // MARK: Properties
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grey80
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.grey80.cgColor

        return imageView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubviews([self.profileNameLabel, self.profileEmailLabel])
        return stackView
    }()
    
    private let profileNameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.text = "불티 로그인 하러가기"
        label.textColor = .grey10

        return label
    }()

    private let profileEmailLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.text = "원하는 공연 티켓을 예매해보세요!"
        label.textColor = .grey30

        return label
    }()
    
    private let loginNavigationButton: UIButton = {
        let button = UIButton()
        button.setImage(.navigate, for: .normal)

        return button
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Methods

extension MypageProfileView {
    func updateProfileUI() {
        self.loginNavigationButton.isHidden = true

        self.profileNameLabel.text =  UserDefaults.userName.isEmpty ? "불티 유저" : UserDefaults.userName
        self.profileEmailLabel.text = UserDefaults.userEmail.isEmpty ? "-" : UserDefaults.userEmail

        let profileImageURLPath = UserDefaults.userImageURLPath

        if profileImageURLPath.isEmpty {
            self.profileImageView.image = .defaultProfile
            self.profileImageView.layer.borderWidth = 0
        } else {
            self.profileImageView.setImage(with: profileImageURLPath)
            self.profileImageView.layer.borderWidth = 1
        }
    }

    func resetProfileUI() {
        self.loginNavigationButton.isHidden = false

        self.profileImageView.image = .defaultProfile
        self.profileNameLabel.text = "불티 로그인 하러가기"
        self.profileEmailLabel.text = "원하는 공연 티켓을 예매해보세요!"
    }
}

// MARK: - UI

extension MypageProfileView {
    
    private func configureUI() {
        self.addSubviews([self.profileImageView,
                          self.labelStackView,
                          self.loginNavigationButton])
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(142)
        }
        
        self.profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(70)
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.profileImageView)
            make.left.equalTo(self.profileImageView.snp.right).offset(12)
        }
        
        self.loginNavigationButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.profileImageView)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
    }
}
