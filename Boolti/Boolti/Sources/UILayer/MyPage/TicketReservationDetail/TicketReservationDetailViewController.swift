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

    typealias ReservationID = String

    private let ticketRefundReasonlViewControllerFactory: (ReservationID) -> TicketRefundReasonViewController

    private let viewModel: TicketReservationDetailViewModel
    private let disposeBag = DisposeBag()

    private let navigationBar = BooltiNavigationBar(type: .ticketReservationDetail)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .grey95
        scrollView.showsVerticalScrollIndicator = false

        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
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

    private let concertInformationView = ConcertInformationView()

    private let bankNameView = ReservationHorizontalStackView(title: "은행명", alignment: .left)
    private let accountNumberView = ReservationHorizontalStackView(title: "계좌번호", alignment: .left, isCopyButtonExist: true)
    private let accountHolderNameView = ReservationHorizontalStackView(title: "예금주", alignment: .left)
    private let depositDeadLineView = ReservationHorizontalStackView(title: "입금 마감일", alignment: .left)

    private lazy var depositAccountInformationStackView = ReservationCollapsableStackView(
        title: "입금 계좌 정보",
        contentViews: [self.bankNameView, self.accountNumberView, self.accountHolderNameView, self.depositDeadLineView],
        isHidden: false
    )

    private let paymentMethodView = ReservationHorizontalStackView(title: "결제 수단", alignment: .right)
    private let totalPaymentAmountView = ReservationHorizontalStackView(title: "총 결제 금액", alignment: .right)
    private let paymentStatusView = ReservationHorizontalStackView(title: "결제 상태", alignment: .right)

    private lazy var paymentInformationStackView = ReservationCollapsableStackView(
        title: "결제 정보",
        contentViews: [self.paymentMethodView, self.totalPaymentAmountView, self.paymentStatusView],
        isHidden: false
    )

    private let ticketTypeView = ReservationHorizontalStackView(title: "티켓 종류", alignment: .right)
    private let ticketCountView = ReservationHorizontalStackView(title: "티켓 개수", alignment: .right)
    private let ticketingDateView = ReservationHorizontalStackView(title: "발권 일시", alignment: .right)

    private lazy var ticketInformationStackView = ReservationCollapsableStackView(
        title: "티켓 정보",
        contentViews: [self.ticketTypeView, self.ticketCountView, self.ticketingDateView],
        isHidden: false
    )

    private let purchasernNameView = ReservationHorizontalStackView(title: "이름", alignment: .right)
    private let purchaserPhoneNumberView = ReservationHorizontalStackView(title: "연락처", alignment: .right)

    private lazy var purchaserInformationStackView = ReservationCollapsableStackView(
        title: "예매자 정보",
        contentViews: [self.purchasernNameView, self.purchaserPhoneNumberView],
        isHidden: true
    )

    private let depositorNameView = ReservationHorizontalStackView(title: "이름", alignment: .right)
    private let depositorPhoneNumberView = ReservationHorizontalStackView(title: "연락처", alignment: .right)

    private lazy var depositorInformationStackView = ReservationCollapsableStackView(
        title: "입금자 정보",
        contentViews: [self.depositorNameView, self.depositorPhoneNumberView],
        isHidden: true
    )

    private let reversalPolicyView = ReversalPolicyView(isWithoutBorder: true)

    private let requestRefundButton: UIButton = {
        let button = UIButton()
        button.setTitle("환불 요청하기", for: .normal)
        button.setTitleColor(.grey90, for: .normal)
        button.titleLabel?.font = .subhead1
        button.backgroundColor = .grey20
        button.layer.cornerRadius = 4

        return button
    }()

    init(
        ticketRefundReasonlViewControllerFactory: @escaping (ReservationID) -> TicketRefundReasonViewController,
        viewModel: TicketReservationDetailViewModel
    ) {
        self.ticketRefundReasonlViewControllerFactory = ticketRefundReasonlViewControllerFactory
        self.viewModel = viewModel
        super.init()
    }

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
        self.bindUIComponents()
        self.bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.contentStackView.isUserInteractionEnabled = true
        self.depositAccountInformationStackView.isUserInteractionEnabled = true
        self.configureToastView(isButtonExisted: false)

        self.view.addSubviews([
            self.navigationBar,
            self.scrollView
        ])

        self.scrollView.addSubview(self.contentStackView)
    }

    private func configureConstraints() {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        let screenWidth = window.screen.bounds.width

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.bottom.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.reservationIDLabel.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
        }

        self.requestRefundButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(screenWidth-40)
        }

        self.addArrangedSubViews()
    }

    private func addArrangedSubViews() {
        self.contentStackView.addArrangedSubviews([
            self.reservationIDLabel,
            self.concertInformationView,
            self.depositAccountInformationStackView,
            self.paymentInformationStackView,
            self.ticketInformationStackView,
            self.purchaserInformationStackView,
            self.depositorInformationStackView,
            self.reversalPolicyView,
            self.requestRefundButton
        ])

        self.contentStackView.setCustomSpacing(40, after: self.reversalPolicyView)
    }

    private func bindUIComponents() {
        self.accountNumberView.didCopyButtonTap
            .bind(with: self) { owner, accountNumber in
                UIPasteboard.general.string = accountNumber
                owner.showToast(message: "계좌번호 복사완료")
            }
            .disposed(by: self.disposeBag)

        self.reversalPolicyView.didViewCollapseButtonTap
            .bind(with: self) { owner, _ in
                owner.scrollToBottom()
            }
            .disposed(by: self.disposeBag)

        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.requestRefundButton.rx.tap
            .bind(with: self) { owner, _ in
                let viewController = owner.ticketRefundReasonlViewControllerFactory(owner.viewModel.reservationID)
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
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
                owner.setData(with: entity)
            }
            .disposed(by: self.disposeBag)
    }

    private func setData(with entity: TicketReservationDetailEntity) {

        // 콘서트 정보
        self.reservationIDLabel.text = "No. \(entity.reservationID)"
        self.concertInformationView.setData(
            posterImageURLPath: entity.concertPosterImageURLPath,
            concertTitle: entity.concertTitle,
            ticketType: entity.ticketType,
            ticketCount: entity.ticketCount
        )

        // 결제 정보
        self.paymentMethodView.setData("초청 코드")
        self.totalPaymentAmountView.setData("\(entity.totalPaymentAmount)원")
        self.paymentStatusView.setData(entity.reservationStatus.description)

        self.configureRefundButton(with: entity.reservationStatus)

        // 티켓 정보
        self.ticketTypeView.setData(entity.ticketType.rawValue)
        self.ticketCountView.setData(entity.ticketCount)
        self.ticketingDateView.setData(entity.ticketingDate?.formatToDate().format(.dateDayTime) ?? "")

        // 예매자 정보
        self.purchasernNameView.setData(entity.purchaseName)
        self.purchaserPhoneNumberView.setData(entity.purchaserPhoneNumber)

        let ticketType = entity.ticketType

        switch ticketType {
        case .sale:
            self.setAdditionalDataForSale(with: entity)
        case .invitation:
            self.configureInvitationUI()
        }
    }

    private func setAdditionalDataForSale(with entity: TicketReservationDetailEntity) {
        if entity.paymentMethod == "초청 코드" {
            self.paymentMethodView.setData("초청코드")
        } else {
            let paymentMethod = PaymentMethod(rawValue: entity.paymentMethod)!
            self.paymentMethodView.setData(paymentMethod.description)
        }

        // 입금 계좌 정보
        self.bankNameView.setData(entity.bankName)
        self.accountNumberView.setData(entity.accountNumber)
        self.accountHolderNameView.setData(entity.accountHolderName)
        self.depositDeadLineView.setData(entity.depositDeadLine.formatToDate().format(.dateDayTime))

        // 입금자 정보
        self.depositorNameView.setData(entity.depositorName)
        self.depositorPhoneNumberView.setData(entity.depositorPhoneNumber)
    }

    private func configureRefundButton(with reservationStatus: ReservationStatus) {
        switch reservationStatus {
        case .reservationCompleted:
            self.requestRefundButton.isHidden = false
            return
        case .waitingForRefund, .refundCompleted, .cancelled, .waitingForDeposit:
            self.requestRefundButton.isHidden = true
        }
    }

    private func configureInvitationUI() {
        self.depositAccountInformationStackView.isHidden = true
        self.depositorInformationStackView.isHidden = true
        self.reversalPolicyView.isHidden = true
        self.requestRefundButton.isHidden = true
    }

    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)

        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }
}
