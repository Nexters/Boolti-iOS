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
        imageView.backgroundColor = .grey90
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let gradientView = UIView()

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
    
    func getLabelStackViewHeight() -> CGFloat {
        return self.nameLabel.getLabelHeight() + 2 + self.introductionLabel.getLabelHeight()
    }
    
    func updateSnsCollectionViewUI(snsCollectionViewHeight: CGFloat,
                                   snsCollectionViewTopOffset: CGFloat) {
        self.snsCollectionView.snp.updateConstraints { make in
            make.height.equalTo(snsCollectionViewHeight)
            make.top.equalTo(self.labelStackView.snp.bottom).offset(snsCollectionViewTopOffset)
        }
    }
    
    func updateProfileImageViewUI(profileViewHeight: CGFloat) {
        self.profileImageView.snp.updateConstraints { make in
            make.height.equalTo(min(profileViewHeight, self.bounds.width))
        }
    }

    func addGradientLayer(profileViewHeight: CGFloat) {
        self.gradientView.layer.sublayers?.removeAll()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: min(profileViewHeight, self.bounds.width))
        gradientLayer.colors = [UIColor("121318").withAlphaComponent(0.2).cgColor,
                                UIColor("121318").withAlphaComponent(1).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        self.gradientView.layer.addSublayer(gradientLayer)
    }

}

// MARK: - UI

extension ProfileMainView {
    
    private func configureUI() {
        self.backgroundColor = .grey90
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        )
        self.addSubviews([self.profileImageView,
                          self.gradientView,
                          self.labelStackView,
                          self.snsCollectionView])
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.profileImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.bounds.width)
        }
        
        self.gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.snsCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(self.labelStackView.snp.bottom).offset(20)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().inset(32)
        }
    }

}
