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
    
    let snsCollectionView: UICollectionView = {
        let layout = SnsCollectionViewLeftAlignedLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(ProfileSnsCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProfileSnsCollectionViewCell.className)
        return collectionView
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

    func setDataForUnknownProfile() {
        self.nameLabel.text = "-"
    }

    func setData(entity: ProfileEntity) {
        self.profileImageView.setImage(with: entity.profileImageURL)
        self.nameLabel.text = entity.nickname
        self.introductionLabel.text = entity.introduction
    }
    
    func getHeight() -> CGFloat {
        return 162 + self.nameLabel.getLabelHeight() + self.introductionLabel.getLabelHeight()
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
                          self.snsCollectionView])
        
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
        
        self.snsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.labelStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(0)
        }
    }

}
