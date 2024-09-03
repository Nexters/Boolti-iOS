//
//  ProfileLinkCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import UIKit

final class ProfileLinkView: UIView {

    // TODO: View가 직접 Entity 가지고 있는 거 수정하기
    private var linkEntity: LinkEntity

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

    init(with linkEntity: LinkEntity) {
        self.linkEntity = linkEntity
        super.init(frame: .zero)

        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI

extension ProfileLinkView {

    private func configureUI() {
        self.addSubviews([self.linkImageView, self.linkNameLabel])
        
        self.linkNameLabel.text = self.linkEntity.title
        self.backgroundColor = .grey90
        self.layer.cornerRadius = 4
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
