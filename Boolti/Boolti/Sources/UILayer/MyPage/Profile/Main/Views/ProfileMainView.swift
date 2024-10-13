//
//  ProfileMainViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ProfileMainView: UIView {
    
    // MARK: Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: UI Components

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grey80
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.grey80.cgColor
        imageView.image = .defaultProfile

        return imageView
    }()

    private let nameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .aggroM(24)
        label.textColor = .grey10
        label.numberOfLines = 0

        return label
    }()
    
    private let introductionLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey30
        label.numberOfLines = 0

        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.addArrangedSubviews([self.nameLabel,
                                       self.introductionLabel])
        
        return stackView
    }()
    
    private let editButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.title = "프로필 편집"
        config.attributedTitle?.font = .pretendardR(12)
        config.background.backgroundColor = .grey80
        config.baseForegroundColor = .grey05
        config.background.cornerRadius = 4
        config.imagePadding = 6
        
        let button = UIButton(configuration: config)
        button.setImage(.pencil, for: .normal)

        return button
    }()
    
    // MARK: Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension ProfileMainView {
    
    func setData(entity: UserProfileResponseDTO, isMyProfile: Bool) {
        self.profileImageView.setImage(with: entity.imgPath ?? "")
        self.nameLabel.text = entity.nickname
        self.introductionLabel.text = entity.introduction ?? ""
        self.editButton.isHidden = !isMyProfile
    }
    
    func getHeight() -> CGFloat {
        let height = self.editButton.isHidden ? 192 : 222
        return CGFloat(height) + self.nameLabel.getLabelHeight() + self.introductionLabel.getLabelHeight()
    }

    func didEditButtonTap() -> Signal<Void> {
        return self.editButton.rx.tap.asSignal()
    }
}

// MARK: - UI

extension ProfileMainView {
    
    private func configureUI() {
        self.backgroundColor = .grey90
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        )
        self.addSubviews([self.profileImageView,
                          self.labelStackView,
                          self.editButton])
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.profileImageView.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(20)
        }

        self.labelStackView.snp.makeConstraints { make in
            make.top.equalTo(self.profileImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.editButton.snp.makeConstraints { make in
            make.top.equalTo(self.labelStackView.snp.bottom).offset(28)
            make.leading.equalTo(self.labelStackView)
            make.bottom.equalToSuperview().inset(32)
        }
    }
}
