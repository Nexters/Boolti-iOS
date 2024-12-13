//
//  SnsTypeCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/14/24.
//

import UIKit

final class SnsTypeCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Components
    
    private let snsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .instagram
        imageView.tintColor = .grey30
        return imageView
    }()

    // MARK: Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Override

    override var isSelected: Bool{
        didSet {
            if isSelected {
                self.contentView.layer.borderColor = UIColor.orange01.cgColor
                self.contentView.layer.borderWidth = 1
            } else {
                self.contentView.layer.borderWidth = 0
            }
        }
    }

    override func prepareForReuse() {
        self.resetData()
    }

}

// MARK: - Methods

extension SnsTypeCollectionViewCell {
    
    func setData(with snsType: SNSType) {
        self.snsImageView.image = snsType.image
    }

    private func resetData() {
        self.snsImageView.image = nil
    }

}

// MARK: - UI

extension SnsTypeCollectionViewCell {
    
    private func configureUI() {
        self.contentView.backgroundColor = .grey85
        self.contentView.layer.cornerRadius = 24
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(self.snsImageView)
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.snsImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(28)
        }
    }
    
}
