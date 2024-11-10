//
//  BusinessInfoCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/13/24.
//

import UIKit

import RxSwift
import RxCocoa

final class BusinessInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    let businessInfoView = BooltiBusinessInfoView()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
    }
}

// MARK: - UI

extension BusinessInfoCollectionViewCell {
    
    private func configureUI() {
        self.contentView.addSubview(self.businessInfoView)
    }
    
    private func configureConstraints() {
        self.businessInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
