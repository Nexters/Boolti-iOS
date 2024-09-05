//
//  EditLinkCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/5/24.
//

import UIKit

final class EditLinkCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Components

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead1
        label.textColor = .grey15
        return label
    }()
    
    private let urlLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey30
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        stackView.addArrangedSubviews([self.titleLabel,
                                       self.urlLabel])
        return stackView
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(.pencil.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .grey50
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
    
    // MARK: - Override
    
    override func prepareForReuse() {
        self.resetData()
    }

}

// MARK: - Methods

extension EditLinkCollectionViewCell {
    
    private func resetData() {
        self.titleLabel.text = nil
        self.urlLabel.text = nil
    }
    
    func setData(title: String, url: String) {
        self.titleLabel.text = title
        self.urlLabel.text = url
    }

}

// MARK: - UI

extension EditLinkCollectionViewCell {

    private func configureUI() {
        self.contentView.backgroundColor = .grey90
        self.contentView.addSubviews([self.labelStackView,
                                      self.editButton])
    }
    
    private func configureConstraints() {
        self.labelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(self.labelStackView)
            make.size.equalTo(20)
        }
    }
    
}
