//
//  BannerCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/28/24.
//

import UIKit

final class BannerCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Component
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = .bannerBackground
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let fireImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = .bannerFire
        return imageView
    }()
    
    private let subTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .caption
        label.textColor = .grey05
        label.text = "지금 공연의 불을 지펴보세요!"
        return label
    }()

    private let mainTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .aggroB(16)
        label.textColor = .grey05
        label.text = "공연 등록하러 가기"
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.addArrangedSubviews([self.subTitleLabel,
                                       self.mainTitleLabel])
        return stackView
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI

extension BannerCollectionViewCell {
    
    private func configureUI() {
        self.contentView.addSubview(self.backgroundImageView)
        self.backgroundImageView.addSubviews([self.fireImageView,
                                              self.labelStackView])
    }
    
    private func configureConstraints() {
        self.backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.fireImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.height.equalToSuperview()
            make.width.equalTo(self.fireImageView.snp.height)
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
    }
}
