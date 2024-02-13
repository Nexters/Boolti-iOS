//
//  TicketRefundConfirmViewController.swift
//  Boolti
//
//  Created by Miro on 2/14/24.
//

import UIKit

final class TicketRefundConfirmViewController: BooltiViewController {

    private let viewModel: TicketRefundConfirmViewModel

    private let contentBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 8

        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환불 정보를 확인해 주세요"
        label.font = .subhead2
        label.textColor = .grey15

        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)

        return button
    }()

    private let refundInformationContentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey80

        return view
    }()

    private let accountHolderNameView = RefundConfirmContentView(title: "예금주")
    private let accountHolderPhoneNumberView = RefundConfirmContentView(title: "연락처")
    private let accountBankNameView = RefundConfirmContentView(title: "은행명")
    private let accountNumberView = RefundConfirmContentView(title: "계좌번호")

    private let requestRefundButton: BooltiButton = {
        let button = BooltiButton(title: "환불 요청하기")

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }

    init(viewModel: TicketRefundConfirmViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.setData()
        self.configureConstraints()
    }

    private func setData() {
        let information = self.viewModel.refundAccountInformation
        let holderName = information.accountHolderName
        let holderPhoneNumber = information.accountHolderPhoneNumber
        let accountBankName = information.accountBankName
        let accountNumber = information.accountNumber

        self.accountHolderNameView.setData(with: holderName)
        self.accountHolderPhoneNumberView.setData(with: holderPhoneNumber)
        self.accountBankNameView.setData(with: accountBankName)
        self.accountNumberView.setData(with: accountNumber)

        self.view.addSubviews([
            self.contentBackGroundView,
            self.titleLabel,
            self.closeButton,
            self.refundInformationContentBackgroundView,
            self.accountHolderNameView,
            self.accountHolderPhoneNumberView,
            self.accountBankNameView,
            self.accountNumberView,
            self.requestRefundButton
        ])
    }

    private func configureConstraints() {
        self.contentBackGroundView.snp.makeConstraints { make in
            make.height.equalTo(334)
            make.width.equalTo(311)
            make.center.equalToSuperview()
        }

        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.contentBackGroundView.snp.top).inset(12)
            make.right.equalTo(self.contentBackGroundView.snp.right).inset(20)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(311)
        }

        self.refundInformationContentBackgroundView.snp.makeConstraints { make in
            make.width.equalTo(271)
            make.height.equalTo(144)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
        }

        self.accountHolderNameView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.refundInformationContentBackgroundView.snp.top).inset(16)
        }

        self.accountHolderPhoneNumberView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.accountHolderNameView.snp.bottom).offset(8)
        }

        self.accountBankNameView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.accountHolderPhoneNumberView.snp.bottom).offset(8)
        }

        self.accountNumberView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.accountBankNameView.snp.bottom).offset(8)
        }

        self.requestRefundButton.snp.makeConstraints { make in
            make.width.equalTo(271)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.contentBackGroundView.snp.bottom).inset(20)
        }
    }
}
