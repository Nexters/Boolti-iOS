//
//  OrganizerInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/5/24.
//

import UIKit

final class OrganizerInfoView: UIView {
    
    // MARK: UI Component
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey10
        label.font = .subhead2
        label.text = "공연 관련 문의"
        
        return label
    }()
    
    private let organizerLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body3
        
        return label
    }()
    
    private let phoneButton: UIButton = {
        let button = UIButton()
        button.setImage(.phone, for: .normal)
        
        return button
    }()
    
    private let messageButton: UIButton = {
        let button = UIButton()
        button.setImage(.message, for: .normal)
        
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

extension OrganizerInfoView {
    
    func setData(hostName: String) {
        self.organizerLabel.text = "\(hostName)"
    }
}

// MARK: - UI

extension OrganizerInfoView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel,
                          self.organizerLabel,
                          self.phoneButton,
                          self.messageButton])
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(170)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.organizerLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(self.titleLabel)
            make.trailing.equalTo(self.phoneButton.snp.leading).offset(-20)
        }
        
        self.phoneButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.organizerLabel)
            make.trailing.equalTo(self.messageButton.snp.leading).offset(-20)
            make.size.equalTo(24)
        }
        
        self.messageButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.organizerLabel)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
    }
}
