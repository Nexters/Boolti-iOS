//
//  PaymentCompletionView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/1/24.
//

import UIKit

final class PaymentCompletionView: UIView {
    
    // MARK: UI Component
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .point4
        label.textColor = .grey05
        label.text = "결제가 완료되었어요"
        return label
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI

extension PaymentCompletionView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel])
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(74)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
