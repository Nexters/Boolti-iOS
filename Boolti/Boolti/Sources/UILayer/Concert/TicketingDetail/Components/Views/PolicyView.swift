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
    let policyLabelHeight = PublishRelay<CGFloat>()
    
    // MARK: UI Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "취소/환불 규정"
        label.font = .subhead2
        label.textColor = .grey10
        return label
    }()
    
    private let chevronButton: UIButton = {
        let button = UIButton()
        button.setImage(.chevronDown, for: .normal)
        button.setImage(.chevronUp, for: .selected)
        return button
    }()
    
    private let policyLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .grey50
        label.text = "-하단에 나열된 내용은 전부 임시 텍스트 입니다.\n-입장 확인이 된 티켓이 있을경우 환불이 불가합니다.\n-환불 방법 : 티켓 예매 상세내역 > 예매취소"
        label.setLineSpacing(lineSpacing: 6)
        label.isHidden = true
        label.lineBreakMode = .byWordWrapping
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
                
                if owner.chevronButton.isSelected {
                    owner.snp.updateConstraints { make in
                        make.height.equalTo(66 + owner.policyLabel.getLabelHeight() + 40)
                    }
                    owner.policyLabelHeight.accept(66 + owner.policyLabel.getLabelHeight() + 40)
                } else {
                    owner.snp.updateConstraints { make in
                        make.height.equalTo(66)
                    }
                    owner.policyLabelHeight.accept(66)
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
