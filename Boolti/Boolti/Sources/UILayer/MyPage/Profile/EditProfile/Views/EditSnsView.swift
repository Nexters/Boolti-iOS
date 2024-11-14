//
//  LinkSnsView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/14/24.
//

import UIKit

import RxSwift

final class EditSnsView: UIView {

    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Components
    
    private let snsLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "SNS"
        return label
    }()
    
    let snsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .zero
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UI

extension EditSnsView {
    
    private func configureUI() {
        self.backgroundColor = .grey90
        self.addSubviews([self.snsLabel,
                          self.snsCollectionView])
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.snsLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        self.snsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.snsLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
    }
    
}
