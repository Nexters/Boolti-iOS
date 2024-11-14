//
//  ProfileConcertCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/12/24.
//

import UIKit

final class ProfileConcertCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Component
    
    private let poster: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .grey30
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        return view
    }()
    
    private lazy var labelStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 2
        view.axis = .vertical
        view.alignment = .fill
        
        view.addArrangedSubviews([self.titleLabel, self.datetimeLabel])
        return view
    }()
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .aggroB(14)
        label.numberOfLines = 2
        label.textColor = .grey05
        return label
    }()
    
    private let datetimeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey30
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

extension ProfileConcertCollectionViewCell {
    
    func setData(posterURL: String, title: String, datetime: Date) {
        self.poster.setImage(with: posterURL)
        self.titleLabel.text = title
        self.datetimeLabel.text = datetime.format(.dateDayTimeWithSlash)
    }
    
    private func resetData() {
        self.poster.image = nil
        self.titleLabel.text = nil
        self.datetimeLabel.text = nil
    }
    
}

// MARK: - UI

extension ProfileConcertCollectionViewCell {
    
    private func configureUI() {
        self.contentView.addSubviews([self.poster,
                                      self.labelStackView])

        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.poster.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.width.equalTo(68)
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.poster)
            make.leading.equalTo(self.poster.snp.trailing).offset(16)
            make.right.equalToSuperview()
        }
    }
    
}
