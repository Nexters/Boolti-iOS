//
//  TicketInquiryView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

final class TicketInquiryView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "공연 관련 문의"
        label.font = .subhead2
        label.textColor = .grey15

        return label
    }()

    private let hostNameLabel: UILabel = {
        let label = UILabel()
        label.font = .body3
        label.textColor = .grey30

        return label
    }()

    private let phoneCallButton: UIButton = {
        let button = UIButton()
        button.setImage(.phone, for: .normal)
        return button
    }()

    private let messageButton: UIButton = {
        let button = UIButton()
        button.setImage(.message, for: .normal)
        return button
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // API 붙힐 때, 수정할 예정!..
    func setData(with information: String) {
        self.hostNameLabel.text = "\(information)"
    }

    private func configureUI() {
        self.addSubviews([
            self.titleLabel,
            self.hostNameLabel,
            self.phoneCallButton,
            self.messageButton
        ])

        self.snp.makeConstraints { make in
            make.height.equalTo(96)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview()
        }

        self.hostNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.left.equalTo(self.titleLabel)
        }

        self.messageButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(self.hostNameLabel)
            make.right.equalTo(self.titleLabel.snp.right)
        }

        self.phoneCallButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(self.hostNameLabel)
            make.right.equalTo(self.messageButton.snp.left).offset(-20)
        }

    }
}
