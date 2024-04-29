//
//  PolicyView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit

import RxSwift
import RxRelay

final class PolicyView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "취소/환불 규정"
        return label
    }()
    
    private let chevronButton: UIButton = {
        let button = UIButton()
        button.setImage(.chevronDown, for: .normal)
        button.setImage(.chevronUp, for: .selected)
        return button
    }()
    
    private let policyLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.textColor = .grey50
        label.text = AppInfo.reversalPolicy
        label.setHeadIndent()
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
        self.bindInputs()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension PolicyView {
    
    private func bindInputs() {
        self.chevronButton.rx.tap
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.chevronButton.isSelected.toggle()
                owner.policyLabel.isHidden.toggle()
                
                var constraint: CGFloat = 66
                if owner.chevronButton.isSelected {
                    constraint = 66 + owner.policyLabel.getLabelHeight() + 40
                }
                
                owner.snp.updateConstraints { make in
                    make.height.equalTo(constraint)
                }
            }).disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension PolicyView {
    
    private func configureUI() {
        self.addSubviews([titleLabel, chevronButton, policyLabel])
        
        self.backgroundColor = .grey90
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(66)
        }
      
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }
        
        self.chevronButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.right.equalToSuperview().inset(20)
            make.height.width.equalTo(24)
        }
        
        self.policyLabel.snp.makeConstraints { make in
            make.top.equalTo(self.chevronButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
