//
//  TicketReservationDetailViewController.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import UIKit

import RxSwift
import RxAppState
import RxCocoa

final class TicketReservationDetailViewController: BooltiViewController {

    private let viewModel: TicketReservationDetailViewModel
    private let disposeBag = DisposeBag()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.showsVerticalScrollIndicator = false

        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 12

        return stackView
    }()

    private let reservationIDLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 0))
        label.textColor = .grey50
        label.font = .pretendardR(14)
        label.text = "No. 1234567890"

        return label
    }()

    private let bankNameView = ReservationHorizontalStackView(title: "은행명", alignment: .left)
    private let accountNumberView = ReservationHorizontalStackView(title: "계좌번호", alignment: .left)
    private let accountHolderNameView = ReservationHorizontalStackView(title: "예금주", alignment: .left)
    private let depositDeadLineView = ReservationHorizontalStackView(title: "입금 마감일", alignment: .left)

    private lazy var depositAccountInformationStackView = ReservationCollapsableStackView(title: "입금 계좌 정보", contentViews: [
        self.bankNameView,
        self.accountNumberView,
        self.accountHolderNameView,
        self.depositDeadLineView
    ])

    private let paymentMethodView = ReservationHorizontalStackView(title: "결제 수단", alignment: .right)
    private let totalPaymentAmountView = ReservationHorizontalStackView(title: "총 결제 금액", alignment: .right)
    private let paymentStatusView = ReservationHorizontalStackView(title: "결제 상태", alignment: .right)

    private lazy var paymentInformationStackView = ReservationCollapsableStackView(title: "결제 정보", contentViews: [
        self.paymentMethodView,
        self.totalPaymentAmountView,
        self.paymentStatusView,
    ])

    private let ticketTypeView = ReservationHorizontalStackView(title: "티켓 종류", alignment: .right)
    private let numberOfTicketsView = ReservationHorizontalStackView(title: "티켓 개수", alignment: .right)
    private let ticketingDateView = ReservationHorizontalStackView(title: "발권 일시", alignment: .right)

    private lazy var ticketInformationStackView = ReservationCollapsableStackView(title: "티켓 정보", contentViews: [
        self.ticketTypeView,
        self.numberOfTicketsView,
        self.ticketingDateView,
    ])

    private let purchasernNameView = ReservationHorizontalStackView(title: "이름", alignment: .right)
    private let purchaserPhoneNumberView = ReservationHorizontalStackView(title: "연락처", alignment: .right)

    private lazy var purchaserInformationStackView = ReservationCollapsableStackView(title: "예매자 정보", contentViews: [
        self.purchasernNameView,
        self.purchaserPhoneNumberView,
    ])

    private let depositorNameView = ReservationHorizontalStackView(title: "이름", alignment: .right)
    private let depositorPhoneNumberView = ReservationHorizontalStackView(title: "연락처", alignment: .right)

    private lazy var depositorInformationStackView = ReservationCollapsableStackView(title: "입금자 정보", contentViews: [
        self.depositorNameView,
        self.depositorPhoneNumberView,
    ])

    private let reveralPolicyView = ReversalPolicyView(isWithoutBorder: true)

    init(viewModel: TicketReservationDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private let navigationBar = BooltiNavigationBar(type: .ticketReservationDetail)

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .red
        self.navigationController?.navigationBar.isHidden = true

        self.view.addSubviews([
            self.navigationBar,
            self.scrollView
        ])

        self.scrollView.addSubview(self.contentStackView)
    }

    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(50)
            make.bottom.horizontalEdges.equalToSuperview()
        }

        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }


        self.contentStackView.addArrangedSubviews([
            self.reservationIDLabel,
            self.depositAccountInformationStackView,
            self.paymentInformationStackView,
            self.ticketInformationStackView,
            self.purchaserInformationStackView,
            self.depositorInformationStackView,
            self.reveralPolicyView
        ])
    }
}
