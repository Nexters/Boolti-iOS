//
//  SearchBarCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/10/24.
//

import UIKit

final class SearchBarCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    private let searchBar = BooltiTextField(isSearchBar: true)
    
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

extension SearchBarCollectionViewCell {
    
    private func configureUI() {
        self.addSubview(self.searchBar)
        
        self.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(16)
        }
    }
}
