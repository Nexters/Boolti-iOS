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
        label.lineBreakMode = .byWordWrapping
        label.text = """
        • 티켓 판매 기간 내 발권 취소 및 환불은 서비스 내 처리가 가능하며, 판매 기간 이후에는 주최자에게 직접 연락 바랍니다.
        • 티켓 판매 기간 내 환불 신청은 발권 후 마이 > 예매 내역 > 예매 상세에서 가능합니다.
        • 계좌 이체를 통한 환불은 환불 계좌 정보가 필요하며 영업일 기준 약 1~2일이 소요됩니다.
        • 환불 수수료는 부과되지 않습니다.
        • 기타 사항은 카카오톡 채널 @스튜디오불티로 문의 부탁드립니다.
        """
        label.setLineSpacingAndHeadIndent(lineSpacing: 6)
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
