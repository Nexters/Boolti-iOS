//
//  ProfileLinkCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import UIKit

final class ProfileLinkCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Component
    
    private let linkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .link
        
        return imageView
    }()
    
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

extension ProfileLinkCollectionViewCell {
    
    func setData(linkName: String) {
        self.linkNameLabel.text = linkName
    }
    
    private func resetData() {
        self.linkNameLabel.text = nil
    }
}

// MARK: - UI

extension ProfileLinkCollectionViewCell {
    
    private func configureUI() {
        self.contentView.addSubviews([self.linkImageView,
                                      self.linkNameLabel])
        
        self.contentView.layer.cornerRadius = 4
        self.contentView.backgroundColor = .grey90
        self.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.linkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
        
        self.linkNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.linkImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
