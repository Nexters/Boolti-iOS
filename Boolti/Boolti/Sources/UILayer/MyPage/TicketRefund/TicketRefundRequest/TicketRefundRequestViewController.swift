//
//  TicketRefundRequestViewController.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

import RxSwift
import RxAppState
import RxCocoa

class TicketRefundRequestViewController: BooltiViewController {

    private let viewModel: TicketRefundRequestViewModel
    private let disposeBag = DisposeBag()

    private let navigationBar = BooltiNavigationBar(type: .defaultUI(backButtonTitle: "환불 요청하기"))
    private let concertInformationView = ConcertInformationView()

    private let accountHolderNameView = RefundHorizontalStackView(title: "이름", placeHolder: "실명을 입력해 주세요")
    private let accountHolderPhoneNumberView = RefundHorizontalStackView(title: "연락처", placeHolder: "숫자만 입력해 주세요")
    private lazy var accountHolderView = ReservationCollapsableStackView(
        title: "예금주 정보",
        contentViews: [self.accountHolderNameView, self.accountHolderPhoneNumberView],
        isHidden: false
    )

    private let refundAccountInformationView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey90

        return view
    }()

    private let refundAccountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "환불 계좌 정보"
        label.font = .subhead2
        label.textColor = .grey10

        return label
    }()

    private let selectRefundBankView = SelectRefundBankView()

    private let accountNumberTextField: BooltiTextField = {
        let textField = BooltiTextField()
        textField.setPlaceHolderText(placeholder: "계좌번호를 입력해 주세요")

        return textField
    }()

    private let requestRefundButton = BooltiButton(title: "환불 요청하기")

    init(viewModel: TicketRefundRequestViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.requestRefundButton.isEnabled = false

        self.refundAccountInformationView.addSubviews([
            self.refundAccountTitleLabel,
            self.selectRefundBankView,
            self.accountNumberTextField
        ])

        self.view.addSubviews([
            self.navigationBar,
            self.concertInformationView,
            self.accountHolderView,
            self.refundAccountInformationView,
            self.requestRefundButton
        ])

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.concertInformationView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
        }

        self.accountHolderView.snp.makeConstraints { make in
            make.top.equalTo(self.concertInformationView.snp.bottom)
        }

        self.refundAccountInformationView.snp.makeConstraints { make in
            make.height.equalTo(194)
            make.top.equalTo(self.accountHolderView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }

        self.refundAccountTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
        }

        self.selectRefundBankView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(self.refundAccountTitleLabel.snp.bottom).offset(20)
        }

        self.accountNumberTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(self.selectRefundBankView.snp.bottom).offset(12)
        }

        self.requestRefundButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
        }

        self.configureAccountHolderViewSpacing()
    }

    private func configureAccountHolderViewSpacing() {
        let subview = self.accountHolderView.arrangedSubviews[1]
        self.accountHolderView.setCustomSpacing(16, after: subview)
    }

    private func bindViewModel() {
        self.bindInputs()
        self.bindOutputs()
    }

    private func bindInputs() {
        self.rx.viewWillAppear
            .asDriver(onErrorJustReturn: true)
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.input.viewWillAppearEvent.accept(())
            })
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {
        self.viewModel.output.tickerReservationDetail
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, entity in
                owner.concertInformationView.setData(
                    posterImageURLPath: entity.concertPosterImageURLPath,
                    concertTitle: entity.concertTitle,
                    ticketType: entity.ticketType,
                    ticketCount: entity.ticketCount
                )
            }
            .disposed(by: self.disposeBag)

    }

}
