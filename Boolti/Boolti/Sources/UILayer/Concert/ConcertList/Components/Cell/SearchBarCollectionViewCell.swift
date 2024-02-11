//
//  SearchBarCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/10/24.
//

import UIKit

final class SearchBarCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    private let searchBarTextField: BooltiTextField = {
        let textField = BooltiTextField(withRightButton: true)
        textField.setPlaceHolderText(placeholder: "공연명으로 검색해 주세요")
        return textField
    }()
    
    private let searchButton = {
        let button = UIButton()
        button.setImage(.search, for: .normal)
        return button
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

extension SearchBarCollectionViewCell {
    
    private func configureUI() {
        self.addSubviews([self.searchBarTextField, self.searchButton])
        
        self.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.searchBarTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(16)
        }
    
        self.searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.searchBarTextField.snp.right).offset(-12)
            make.height.width.equalTo(24)
        }
    }
}
