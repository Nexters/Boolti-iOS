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
        label.text = "주최자"
        
        return label
    }()
    
    private let organizerLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        label.textColor = .grey30
        label.font = .body3
        label.backgroundColor = .grey85
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        
        return label
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
    
    func setData(hostName: String, hostPhoneNumber: String) {
        self.organizerLabel.text = "\(hostName) (\(hostPhoneNumber))"
    }
}

// MARK: - UI

extension OrganizerInfoView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.organizerLabel])
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
            make.horizontalEdges.equalTo(self.titleLabel)
        }
    }
}
