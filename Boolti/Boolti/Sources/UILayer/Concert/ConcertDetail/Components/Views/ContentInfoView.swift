//
//  ContentInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/5/24.
//

import UIKit

final class ContentInfoView: UIView {
    
    // MARK: UI Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "공연 내용"
        label.textColor = .grey10
        label.font = .subhead2
        
        return label
    }()
    
    private let expandButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 40, bottom: 2, trailing: 0)
        config.title = "전체보기"
        config.attributedTitle?.font = .body1
        config.baseForegroundColor = .grey50
        
        let button = UIButton(configuration: config)
        return button
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey30
        label.font = .body3
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        
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

extension ContentInfoView {
    
    func setData(content: String) {
        self.contentLabel.text = content
        self.contentLabel.setLineSpacing(lineSpacing: 4)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(106 + min(self.contentLabel.getLabelHeight(), 246))
        }
    }
}

// MARK: - UI

extension ContentInfoView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.expandButton, self.contentLabel, self.underLineView])
    }
    
    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.expandButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.right.equalTo(self.titleLabel)
        }
        
        self.contentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.titleLabel)
            make.height.lessThanOrEqualTo(246)
        }
        
        self.underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(self.contentLabel)
        }
    }
}

