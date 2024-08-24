//
//  ProfileLinkHeaderView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import UIKit

final class ProfileLinkHeaderView: UICollectionReusableView {
    
    // MARK: UI Components
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "SNS 링크"
        return label
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

extension ProfileLinkHeaderView {
    
    private func configureUI() {
        self.addSubview(self.titleLabel)
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(32)
        }
    }
    
}
