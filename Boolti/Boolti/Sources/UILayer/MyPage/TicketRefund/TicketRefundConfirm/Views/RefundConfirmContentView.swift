//
//  RefundConfirmContentView.swift
//  Boolti
//
//  Created by Miro on 2/14/24.
//

import UIKit

final class RefundConfirmContentView: UIView {

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .body1
        label.textAlignment = .left

        return label
    }()

    private let contentLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey15
        label.font = .body1
        label.textAlignment = .left

        return label
    }()

    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.configureUI()
    }

    func setData(with item: String) {
        self.contentLabel.text = item
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubviews([
            self.titleLabel,
            self.contentLabel
        ])

        self.snp.makeConstraints { make in
            make.height.equalTo(22)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(82)
        }

        self.contentLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
        }
    }
}
