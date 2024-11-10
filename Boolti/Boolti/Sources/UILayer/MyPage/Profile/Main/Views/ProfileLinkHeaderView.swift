//
//  ProfileLinkHeaderView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import UIKit

import RxSwift

final class ProfileLinkHeaderView: UICollectionReusableView {
    
    // MARK: Properties

    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "링크"
        return label
    }()
    
    let expandButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 40, bottom: 2, trailing: 0)
        config.title = "전체보기"
        config.attributedTitle?.font = .body1
        config.baseForegroundColor = .grey50
        
        let button = UIButton(configuration: config)
        return button
    }()
    
    // MARK: Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
}

// MARK: - UI

extension ProfileLinkHeaderView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel,
                          self.expandButton])
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalToSuperview().inset(20)
        }
        
        self.expandButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.trailing.equalToSuperview().inset(20)
            
        }
    }
    
}
