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

    private let hostInformationLabel: UILabel = {
        let label = UILabel()
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
    
    // API 붙힐 때, 수정할 예정!..
    func setData(with information: String) {
        self.hostInformationLabel.text = "주최자   \(information)"
    }

    private func configureUI() {
        self.addSubviews([
            self.titleLabel,
            self.hostInformationLabel
        ])

        self.snp.makeConstraints { make in
            make.height.equalTo(96)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.hostInformationLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.left.equalTo(self.titleLabel)
        }

    }



}
