//
//  BusinessInfoCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/13/24.
//

import UIKit

final class BusinessInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Component
    
    private let businessInfoView = BooltiBusinessInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI

extension BusinessInfoCollectionViewCell {
    
    private func configureUI() {
        self.addSubview(self.businessInfoView)
    }
    
    private func configureConstraints() {
        self.businessInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
