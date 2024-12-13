//
//  EditLinkCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/5/24.
//

import UIKit

final class EditLinkCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Components
    
    private let linkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .link
        imageView.tintColor = .grey30
        return imageView
    }()

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead1
        label.textColor = .grey15
        return label
    }()
    
    private let urlLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey30
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        stackView.addArrangedSubviews([self.titleLabel,
                                       self.urlLabel])
        return stackView
    }()
    
    private let moveImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .move
        imageView.tintColor = .grey70
        return imageView
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

extension EditLinkCollectionViewCell {
    
    private func resetData() {
        self.titleLabel.text = nil
        self.urlLabel.text = nil
    }
    
    func setData(with data: LinkEntity) {
        self.titleLabel.text = data.title
        self.urlLabel.text = data.link
    }

}

// MARK: - UI

extension EditLinkCollectionViewCell {

    private func configureUI() {
        self.contentView.backgroundColor = .grey90
        self.contentView.addSubviews([self.linkImageView,
                                      self.labelStackView,
                                      self.moveImageView])
    }
    
    private func configureConstraints() {
        self.linkImageView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.size.equalTo(24)
        }

        self.labelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.linkImageView)
            make.leading.equalTo(self.linkImageView.snp.trailing).offset(12)
            make.trailing.equalTo(self.moveImageView.snp.leading).offset(-20)
        }
        
        self.moveImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.linkImageView)
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }
    }
}
