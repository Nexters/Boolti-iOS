//
//  PaymentCompletionView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/1/24.
//

import UIKit

final class PaymentCompletionView: UIView {
    
    // MARK: UI Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "결제가 완료되었어요"
        label.font = .point4
        label.textColor = .grey05
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "예매자 정보 확인 후 티켓이 발권됩니다."
        label.font = .body1
        label.textColor = .grey30
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
        view.addArrangedSubviews([self.titleLabel, self.infoLabel])
        return view
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
        self.addSubviews([self.stackView])
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(104)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(20)
        }
    }
}
