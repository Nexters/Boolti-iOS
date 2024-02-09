//
//  CheckingTicketCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/10/24.
//

import UIKit

final class CheckingTicketCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    private let checkingTitle: UILabel = {
        let label = UILabel()
        label.font = .pretendardR(15)
        label.text = "입금 확인 중인 티켓이 있어요!"
        label.textColor = .grey05
        return label
    }()
    
    private let navigateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .navigate
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
}

// MARK: - Methods

extension CheckingTicketCollectionViewCell {
    
    private func configureUI() {
        self.addSubviews([self.checkingTitle,
                          self.navigateImageView])
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.init("#FF6827").cgColor, UIColor.init("#EB955B").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        self.layer.addSublayer(gradientLayer)
        self.layer.cornerRadius = 8
    }
    
    private func configureConstraints() {
        self.checkingTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        self.navigateImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
    }
}

