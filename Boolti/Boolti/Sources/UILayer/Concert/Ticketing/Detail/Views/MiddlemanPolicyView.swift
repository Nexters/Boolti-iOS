//
//  MiddlemanPolicyView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/30/24.
//

import UIKit

final class MiddlemanPolicyView: UIView {
    
    // MARK: Properties
    
    private let descriptionLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .caption
        label.textColor = .grey70
        label.numberOfLines = 0
        label.text = """
        스튜디오 불티는 통신판매중개자로 통신판매의 당사자가 아닙니다.
        불티에서 판매되는 상품에 대한 광고, 상품주문, 배송, 환불의 의무와 책임은 각 판매자에게 있습니다.
        """
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI

extension MiddlemanPolicyView {
    
    private func configureUI() {
        self.addSubview(self.descriptionLabel)
        self.backgroundColor = .clear
    }
    
    private func configureConstraints() {
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
