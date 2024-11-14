//
//  ProfileSnsCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/13/24.
//

import UIKit

final class ProfileSnsCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Component
    
    private let linkImageView = UIImageView()
    
    private let linkNameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey15
        
        return label
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
    
    // MARK: - Override
    
    override func prepareForReuse() {
        self.resetData()
    }

}

// MARK: - Methods

extension ProfileSnsCollectionViewCell {

    func setData(snsType: SNSType, linkName: String) {
        switch snsType {
        case .instagram:
            self.linkImageView.image = .instagram
        case .youtube:
            self.linkImageView.image = .youtube
        }
        self.linkNameLabel.text = linkName
    }
    
    private func resetData() {
        self.linkImageView.image = nil
        self.linkNameLabel.text = nil
    }

}

// MARK: - UI

extension ProfileSnsCollectionViewCell {
    
    private func configureUI() {
        self.contentView.addSubviews([self.linkImageView,
                                      self.linkNameLabel])
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.backgroundColor = .grey80
    }
    
    private func configureConstraints() {
        self.linkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.size.equalTo(20)
        }
        
        self.linkNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.linkImageView.snp.trailing).offset(6)
            make.trailing.equalToSuperview().inset(12)
        }
    }

}
