//
//  EditSnsCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/14/24.
//

import UIKit

final class EditSnsCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Components
    
    private let snsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .instagram
        imageView.tintColor = .grey30
        return imageView
    }()

    private let typeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey30
        return label
    }()
    
    private let nameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead1
        label.textColor = .grey15
        return label
    }()
    
    private let editImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .pencil
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

extension EditSnsCollectionViewCell {
    
    private func resetData() {
        self.snsImageView.image = nil
        self.typeLabel.text = nil
        self.nameLabel.text = nil
    }
    
    func setData(with data: SnsEntity) {
        self.snsImageView.image = data.snsType.image
        self.typeLabel.text = data.snsType.rawValue
        self.nameLabel.text = data.name
    }

}

// MARK: - UI

extension EditSnsCollectionViewCell {

    private func configureUI() {
        self.contentView.backgroundColor = .grey90
        self.contentView.addSubviews([self.snsImageView,
                                      self.typeLabel,
                                      self.nameLabel,
                                      self.editImageView])
    }
    
    private func configureConstraints() {
        self.snsImageView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.size.equalTo(24)
        }
        
        self.typeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snsImageView)
            make.leading.equalTo(self.snsImageView.snp.trailing).offset(8)
            make.width.equalTo(72)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snsImageView)
            make.leading.equalTo(self.typeLabel.snp.trailing).offset(16)
            make.trailing.equalTo(self.editImageView.snp.leading).offset(-16)
        }
        
        self.editImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snsImageView)
            make.trailing.equalToSuperview()
            make.size.equalTo(20)
        }
    }
}
