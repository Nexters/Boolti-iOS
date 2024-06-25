//
//  CardImageCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 6/25/24.
//

import UIKit

final class CardImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Component
    
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grey50
        imageView.layer.cornerRadius = 4
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
    
}

// MARK: - Methods

extension CardImageCollectionViewCell {
    
    func setData(with urlString: String) {
        self.cardImageView.setImage(with: urlString)
    }
    
}

// MARK: - UI

extension CardImageCollectionViewCell {
    
    private func configureUI() {
        self.addSubview(self.cardImageView)
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.cardImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
