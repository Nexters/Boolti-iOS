//
//  ConcertListMainTitleCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/10/24.
//

import UIKit

final class ConcertListMainTitleCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Component
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .point4
        label.textColor = .grey05
        label.numberOfLines = 2
        return label
    }()
    
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

extension ConcertListMainTitleCollectionViewCell {
    
    func setTitle() {
        self.titleLabel.text = "\(UserDefaults.userName.isEmpty ? "불티 유저" : UserDefaults.userName)님, 오늘은\n어떤 공연을 즐겨볼까요?"
    }
}

// MARK: - UI

extension ConcertListMainTitleCollectionViewCell {
    
    private func configureUI() {
        self.contentView.addSubview(self.titleLabel)
    }
    
    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
