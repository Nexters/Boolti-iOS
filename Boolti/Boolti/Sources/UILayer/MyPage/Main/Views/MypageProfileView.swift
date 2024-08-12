//
//  MypageProfileView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/17/24.
//

import UIKit

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
    }

    func resetProfileUI() {
        self.profileImageView.isHidden = true
        self.profileNameLabel.text = "로그인하고 이용해 보세요"
    }
}

// MARK: - UI

extension MypageProfileView {
    
    private func configureUI() {
        self.addSubviews([self.profileStackView])
        
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
    }
}
