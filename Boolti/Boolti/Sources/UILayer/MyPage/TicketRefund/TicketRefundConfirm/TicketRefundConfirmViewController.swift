//
//  TicketRefundConfirmViewController.swift
//  Boolti
//
//  Created by Miro on 2/14/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxRelay

final class TicketRefundConfirmViewController: BooltiViewController {

    private let viewModel: TicketRefundConfirmViewModel

    private let disposeBag = DisposeBag()

    private let contentBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 8

        return view
    }()

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey15
        label.text = "환불 정보를 확인해 주세요"

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
        view.layer.cornerRadius = 4

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
        self.configureToastView(isButtonExisted: false)
        self.bindViewModel()
        self.bindUIComponents()
    }

    private func setData() {
        let information = self.viewModel.refundAccountInformation
        let holderName = information.accountHolderName
        let holderPhoneNumber = information.accountHolderPhoneNumber.formatPhoneNumber()
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
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }

        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.contentBackGroundView.snp.top).inset(12)
            make.right.equalTo(self.contentBackGroundView.snp.right).inset(20)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.closeButton.snp.bottom).offset(12)
        }

        self.refundInformationContentBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.contentBackGroundView).inset(20)
            make.height.equalTo(168)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
        }

        self.accountHolderNameView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(self.refundInformationContentBackgroundView).inset(20)
            make.top.equalTo(self.refundInformationContentBackgroundView.snp.top).inset(16)
        }

        self.accountHolderPhoneNumberView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(self.accountHolderNameView)
            make.top.equalTo(self.accountHolderNameView.snp.bottom).offset(16)
        }

        self.accountBankNameView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(self.accountHolderNameView)
            make.top.equalTo(self.accountHolderPhoneNumberView.snp.bottom).offset(16)
        }

        self.accountNumberView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(self.accountHolderNameView)
            make.top.equalTo(self.accountBankNameView.snp.bottom).offset(16)
        }

        self.requestRefundButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.contentBackGroundView).inset(20)
            make.top.equalTo(self.refundInformationContentBackgroundView.snp.bottom).offset(28)
            make.bottom.equalTo(self.contentBackGroundView).offset(-20)
        }
    }

    private func bindUIComponents() {
        self.closeButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {
        self.bindInput()
        self.bindOutput()
    }

    private func bindInput() {
        self.requestRefundButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didRequestFundButtonTapEvent.accept(())
            }
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {
        self.viewModel.output.didRequestFundCompleted
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                guard let refundRequestViewController = owner.presentingViewController as? TicketRefundRequestViewController else { return }
                guard let viewControllers = refundRequestViewController.navigationController?.viewControllers else { return }
                guard let reservationListViewControllers = viewControllers.filter({ $0 is TicketReservationsViewController }).first as? TicketReservationsViewController else { return }

                owner.showToast(message: "환불 요청이 완료되었어요")
                owner.dismiss(animated: true) {
                    refundRequestViewController.navigationController?.popToViewController(reservationListViewControllers, animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
