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

    private let refundTypeView = RefundConfirmContentView(title: "환불 수단")
    private let totalRefundAmountView = RefundConfirmContentView(title: "환불 예정 금액")

    private let requestRefundButton: BooltiButton = {
        let button = BooltiButton(title: "취소 요청하기")

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
        self.configureSubviews()
        self.bindViewModel()
        self.bindUIComponents()
    }

    private func configureSubviews() {
        self.view.addSubviews([
            self.contentBackGroundView,
            self.titleLabel,
            self.closeButton,
            self.refundInformationContentBackgroundView,
            self.refundTypeView,
            self.totalRefundAmountView,
            self.requestRefundButton
        ])
        self.configureConstraints()
        self.setData()
        self.configureToastView(isButtonExisted: false)
    }

    private func setData() {
        let information = self.viewModel.refundAccountInformation
        let totalRefundAmount = information.totalRefundAmount
        let refundMethod = information.refundMethod

        self.totalRefundAmountView.setData(with: "\(totalRefundAmount)원")
        self.configureRefundMethodView(with: refundMethod)
    }

    private func configureRefundMethodView(with refundMethod: String?) {
        if let refundMethod { // 무료 티켓 외
            self.refundTypeView.setData(with: refundMethod)
        } else { // 무료 티켓
            self.refundTypeView.removeFromSuperview()
            self.contentBackGroundView.snp.makeConstraints { make in
                make.height.equalTo(244)
            }
        }
    }

    private func configureConstraints() {
        self.contentBackGroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(280)
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
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
        }

        self.refundTypeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(self.refundInformationContentBackgroundView).inset(20)
            make.top.equalTo(self.refundInformationContentBackgroundView.snp.top).inset(16)
        }

        self.totalRefundAmountView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(self.refundInformationContentBackgroundView).inset(20)
            make.bottom.equalTo(self.refundInformationContentBackgroundView).inset(16)
        }

        self.requestRefundButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.contentBackGroundView).inset(20)
            make.top.equalTo(self.refundInformationContentBackgroundView.snp.bottom).offset(28)
            make.bottom.equalTo(self.contentBackGroundView).inset(20)
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
                // TODO: 통합해서 한번에 관리하기
                if owner.viewModel.isGift {
                    guard let refundRequestViewController = owner.presentingViewController as? GiftRefundRequestViewController else { return }
                    guard let viewControllers = refundRequestViewController.navigationController?.viewControllers else { return }
                    guard let reservationDetailViewController = viewControllers.filter({ $0 is GiftReservationDetailViewController }).first as? GiftReservationDetailViewController else { return }
                    owner.showToast(message: "취소 요청이 완료되었어요")
                    owner.dismiss(animated: true) {
                        refundRequestViewController.navigationController?.popToViewController(reservationDetailViewController, animated: true)
                    }
                } else {
                    guard let refundRequestViewController = owner.presentingViewController as? TicketRefundRequestViewController else { return }
                    guard let viewControllers = refundRequestViewController.navigationController?.viewControllers else { return }
                    guard let reservationDetailViewController = viewControllers.filter({ $0 is TicketReservationDetailViewController }).first as? TicketReservationDetailViewController else { return }
                    owner.showToast(message: "취소 요청이 완료되었어요")
                    owner.dismiss(animated: true) {
                        refundRequestViewController.navigationController?.popToViewController(reservationDetailViewController, animated: true)
                    }
                }
            }
            .disposed(by: self.disposeBag)
    }
}
