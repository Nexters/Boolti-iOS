//
//  TicketNoticeView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

final class TicketNoticeView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "안내사항 for 주최자"
        label.font = .subhead2
        label.textColor = .grey15

        return label
    }()

    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.setLineSpacing(lineSpacing: 6)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .body1
        label.textColor = .grey50

        return label
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubviews([
            self.titleLabel,
            self.noticeLabel
        ])

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self.titleLabel)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    func setData(with text: String) {
        self.noticeLabel.text = text
        self.layoutIfNeeded()
    }
}
