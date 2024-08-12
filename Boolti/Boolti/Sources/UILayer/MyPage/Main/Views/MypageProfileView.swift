//
//  MypageProfileView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/17/24.
//

import UIKit

import RxCocoa

final class MypageProfileView: UIView {
    
    // MARK: Properties
    
    var statusBarHeight: CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.statusBarManager?.statusBarFrame.height ?? 44
        }
        return 44
    }
    
    // MARK: UI Components
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grey80
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.grey80.cgColor

        return imageView
    }()

    private let profileNameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .aggroM(24)
        label.textColor = .grey10
        label.text = "로그인하고 이용해 보세요"

        return label
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.addArrangedSubviews([self.profileImageView,
                                       self.profileNameLabel])
        return stackView
    }()
    
    private let loginButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.title = "로그인"
        config.attributedTitle?.font = .pretendardR(12)
        config.background.backgroundColor = .grey80
        config.baseForegroundColor = .grey05
        config.background.cornerRadius = 4
        
        let button = UIButton(configuration: config)
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
        self.profileImageView.isHidden = false
        
        self.profileNameLabel.text =  UserDefaults.userName.isEmpty ? "불티 유저" : UserDefaults.userName

        let profileImageURLPath = UserDefaults.userImageURLPath

        if profileImageURLPath.isEmpty {
            self.profileImageView.image = .defaultProfile
            self.profileImageView.layer.borderWidth = 0
        } else {
            self.profileImageView.setImage(with: profileImageURLPath)
            self.profileImageView.layer.borderWidth = 1
        }
        
        self.loginButton.isHidden = true
    }

    func resetProfileUI() {
        self.profileImageView.isHidden = true
        self.profileNameLabel.text = "로그인하고 이용해 보세요"
        self.loginButton.isHidden = false
    }
    
    func didLoginButtonTap() -> Signal<Void> {
        return self.loginButton.rx.tap.asSignal()
    }
}

// MARK: - UI

extension MypageProfileView {
    
    private func configureUI() {
        self.addSubviews([self.profileStackView,
                          self.loginButton])
        
        self.backgroundColor = .grey90
        self.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        )
        self.layer.cornerRadius = 12
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.statusBarHeight + 92)
        }
        
        self.profileImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        
        self.profileStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(29)
        }
        
        self.loginButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(28)
            make.centerY.equalTo(self.profileStackView)
        }
    }
}
