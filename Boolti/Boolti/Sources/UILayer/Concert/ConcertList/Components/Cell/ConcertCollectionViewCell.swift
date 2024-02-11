//
//  ConcertCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/9/24.
//

import UIKit

final class ConcertCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grey70
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.grey80.cgColor
        return imageView
    }()
    
    private let datetime: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .grey30
        return label
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.font = .point1
        label.textColor = .grey05
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
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

extension ConcertCollectionViewCell {
    
    func setData(concertEntity: ConcertEntity) {
        self.posterImageView.setImage(with: concertEntity.posterPath)
        self.datetime.text = concertEntity.dateTime.format(.dateTime)
        self.name.text = concertEntity.name
        
        self.name.setLineSpacing(lineSpacing: 8)
    }
    
    private func resetData() {
        self.posterImageView.image = nil
        self.datetime.text = nil
        self.name.text = nil
    }
}

// MARK: - UI

extension ConcertCollectionViewCell {
    
    private func configureUI() {
        self.addSubviews([self.posterImageView,
                          self.datetime,
                          self.name])
    }
    
    private func configureConstraints() {
        self.posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(self.posterImageView.snp.width).multipliedBy(1.406)
        }
        
        self.datetime.snp.makeConstraints { make in
            make.top.equalTo(self.posterImageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(22)
        }
        
        self.name.snp.makeConstraints { make in
            make.top.equalTo(self.datetime.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.lessThanOrEqualTo(52)
        }
    }
}
