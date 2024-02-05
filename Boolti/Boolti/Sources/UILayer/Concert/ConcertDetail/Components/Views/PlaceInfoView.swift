//
//  PlaceInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/5/24.
//

import UIKit

final class PlaceInfoView: UIView {
    
    // MARK: UI Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "장소"
        label.textColor = .grey10
        label.font = .subhead2
        
        return label
    }()
    
    private let copyButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.title = "주소복사"
        config.attributedTitle?.font = .pretendardR(12)
        config.background.backgroundColor = .grey85
        config.baseForegroundColor = .grey05
        config.background.cornerRadius = 4
        config.imagePadding = 6
        
        let button = UIButton(configuration: config)
        button.setImage(.placeCopy, for: .normal)
        
        return button
    }()

    
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey10
        label.font = .body3
        
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey30
        label.font = .body3
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let underLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .grey85
        
        return view
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

extension PlaceInfoView {
    
    func setData(name: String, address: String) {
        self.placeNameLabel.text = name
        self.addressLabel.text = address
        
        self.snp.makeConstraints { make in
            make.height.equalTo(138 + self.addressLabel.getLabelHeight())
        }
    }
}

// MARK: - UI

extension PlaceInfoView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.copyButton, self.placeNameLabel, self.addressLabel, self.underLineView])
    }
    
    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.copyButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.right.equalTo(self.titleLabel)
        }
        
        self.placeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.titleLabel)
        }
        
        self.addressLabel.snp.makeConstraints { make in
            make.top.equalTo(self.placeNameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self.placeNameLabel)
        }
        
        self.underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(self.addressLabel)
        }
    }
}

