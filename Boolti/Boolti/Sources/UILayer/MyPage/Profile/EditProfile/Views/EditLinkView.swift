//
//  EditLinkView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/5/24.
//

import UIKit

import RxSwift

final class EditLinkView: UIView {

    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Components
    
    private let linkLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "링크"
        return label
    }()
    
    let linkCollectionView: UICollectionView = {
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

extension EditLinkView {
    
    private func configureUI() {
        self.backgroundColor = .grey90
        self.addSubviews([self.linkLabel,
                          self.linkCollectionView])
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.linkLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        self.linkCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.linkLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalToSuperview().inset(20)
        }
    }
    
}
