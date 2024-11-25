//
//  OrganizerInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/5/24.
//

import UIKit

import RxCocoa

final class OrganizerInfoView: UIView {
    
    // MARK: UI Component
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey10
        label.font = .subhead2
        label.text = "주최"

        return label
    }()
    
    private let organizerLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body3
        
        return label
    }()
    
    private let callButton: UIButton = {
        let button = UIButton()
        button.setImage(.call, for: .normal)
        
        return button
    }()
    
    private let messageButton: UIButton = {
        let button = UIButton()
        button.setImage(.message, for: .normal)
        
        return button
    }()
    
    // MARK: Init

    init(horizontalInset: Int, verticalInset: Int, height: Int) {
        super.init(frame: .zero)

        self.configureUI()
        self.configureConstraints(horizontalInset: horizontalInset, verticalInset: verticalInset, height: height)
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
    
    func didCallButtonTap() -> Signal<Void> {
        return self.callButton.rx.tap.asSignal()
    }
    
    func didMessageButtonTap() -> Signal<Void> {
        return self.messageButton.rx.tap.asSignal()
    }
    
}

// MARK: - UI

extension OrganizerInfoView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel,
                          self.organizerLabel,
                          self.callButton,
                          self.messageButton])
    }
    
    private func configureConstraints(horizontalInset: Int, verticalInset: Int, height: Int) {
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(height+24)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(verticalInset)
            make.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
        
        self.organizerLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(self.titleLabel)
            make.trailing.equalTo(self.callButton.snp.leading).offset(-20)
        }

        self.callButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.organizerLabel)
            make.trailing.equalTo(self.messageButton.snp.leading).offset(-20)
            make.size.equalTo(24)
        }

        self.messageButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.organizerLabel)
            make.trailing.equalToSuperview().inset(horizontalInset)
            make.size.equalTo(24)
        }
    }
}
