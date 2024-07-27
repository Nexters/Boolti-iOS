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

    private let ticketRefundReasonViewControllerFactory: (ReservationID) -> TicketRefundReasonViewController

    private let viewModel: TicketReservationDetailViewModel
    private let disposeBag = DisposeBag()

    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "결제 내역 상세"))

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

    private lazy var reservationUpperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 20, bottom: .zero, right: 20)

        stackView.addArrangedSubviews([
            self.reservationIDLabel,
            self.reservationStatusLabel
        ])

        return stackView
    }()

    private let reservationIDLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey50
        label.font = .pretendardR(14)

        return label
    }()

    private let reservationStatusLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1

        return label
    }()

    private let concertInformationView = ConcertInformationView()

    private let paymentMethodView = ReservationHorizontalStackView(title: "결제 수단", alignment: .right)
    private let totalPaymentAmountView = ReservationHorizontalStackView(title: "총 결제 금액", alignment: .right)

    private lazy var paymentInformationStackView = ReservationCollapsableStackView(
        title: "결제 수단",
        contentViews: [self.totalPaymentAmountView, self.paymentMethodView],
        isHidden: false
    )

    private let ticketTypeView = ReservationHorizontalStackView(title: "티켓 종류", alignment: .right)
    private let ticketCountView = ReservationHorizontalStackView(title: "티켓 매수", alignment: .right)

    private lazy var ticketInformationStackView = ReservationCollapsableStackView(
        title: "티켓 정보",
        contentViews: [self.ticketTypeView, self.ticketCountView],
        isHidden: false
    )

    private let visitorNameView = ReservationHorizontalStackView(title: "이름", alignment: .right)
    private let visitorPhoneNumberView = ReservationHorizontalStackView(title: "연락처", alignment: .right)

    private lazy var visitorInformationStackView = ReservationCollapsableStackView(
        title: "방문자 정보",
        contentViews: [self.visitorNameView, self.visitorPhoneNumberView],
        isHidden: true
    )

    private let depositorNameView = ReservationHorizontalStackView(title: "이름", alignment: .right)
    private let depositorPhoneNumberView = ReservationHorizontalStackView(title: "연락처", alignment: .right)

    private lazy var depositorInformationStackView = ReservationCollapsableStackView(
        title: "결제자 정보",
        contentViews: [self.depositorNameView, self.depositorPhoneNumberView],
        isHidden: true
    )

    private let refundMethodView = ReservationHorizontalStackView(title: "환불 수단", alignment: .right)
    private let totalRefundAmountView = ReservationHorizontalStackView(title: "총 환불 금액", alignment: .right)

    private lazy var refundInformationStackView = ReservationCollapsableStackView(
        title: "환불 내역",
        contentViews: [self.totalRefundAmountView, self.refundMethodView],
        isHidden: false
    )

    private let reversalPolicyView = ReversalPolicyView(isWithoutBorder: true)

    private let requestRefundButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소 요청하기", for: .normal)
        button.setTitleColor(.grey90, for: .normal)
        button.titleLabel?.font = .subhead1
        button.backgroundColor = .grey20
        button.layer.cornerRadius = 4

        return button
    }()

    private let blankSpaceView: UIView = {
        let view = UIView()
        return view
    }()

    init(
        ticketRefundReasonViewControllerFactory: @escaping (ReservationID) -> TicketRefundReasonViewController,
        viewModel: TicketReservationDetailViewModel
    ) {
        self.ticketRefundReasonViewControllerFactory = ticketRefundReasonViewControllerFactory
        self.viewModel = viewModel
        super.init()
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

        self.reversalPolicyView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
        }

        self.requestRefundButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(screenWidth-40)
        }

        self.blankSpaceView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        self.addArrangedSubViews()
    }

    private func addArrangedSubViews() {
        self.contentStackView.addArrangedSubviews([
            self.reservationUpperStackView,
            self.concertInformationView,
            self.visitorInformationStackView,
            self.depositorInformationStackView,
            self.ticketInformationStackView,
            self.paymentInformationStackView,
            self.refundInformationStackView,
            self.reversalPolicyView,
            self.blankSpaceView,
            self.requestRefundButton,
        ])

        self.reservationUpperStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        self.contentStackView.setCustomSpacing(0, after: self.reversalPolicyView)
    }

    private func bindUIComponents() {

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
                let viewController = owner.ticketRefundReasonViewControllerFactory(owner.viewModel.reservationID)
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
        self.reservationIDLabel.text = "No. \(entity.csReservationID)"
        self.reservationStatusLabel.text = entity.reservationStatus.description
        self.reservationStatusLabel.textColor = entity.reservationStatus.color
        self.concertInformationView.setData(
            posterImageURLPath: entity.concertPosterImageURLPath,
            concertTitle: entity.concertTitle,
            salesTicketName: entity.salesTicketName,
            ticketCount: "\(entity.ticketCount)"
        )

        // 티켓 정보
        self.ticketTypeView.setData(entity.salesTicketName)
        self.ticketCountView.setData("\(entity.ticketCount)매")

        // 방문자 정보
        self.visitorNameView.setData(entity.purchaseName)
        self.visitorPhoneNumberView.setData(self.formatPhoneNumber(entity.purchaserPhoneNumber))

        // 결제자 정보
        self.depositorNameView.setData(entity.depositorName)
        self.depositorPhoneNumberView.setData(self.formatPhoneNumber(entity.depositorPhoneNumber))
        
        // 결제 금액
        self.totalPaymentAmountView.setData("\(entity.totalPaymentAmount)원")

        let ticketType = entity.ticketType
        switch ticketType {
        case .sale:
            self.setAdditionalDataForSale(with: entity)
        case .invitation:
            self.configureInvitationUI(with: entity)
        }

        // 환불
        self.configureRefundCase(with: entity)
    }

    private func setAdditionalDataForSale(with entity: TicketReservationDetailEntity) {
        guard let paymentMethod = entity.paymentMethod else { return }
        switch paymentMethod {
        case .accountTransfer:
            self.configureAccountTransferPayment()
        case .card:
            self.configurePaymentCardDetail(with: entity.paymentCardDetail)
        case .simplePayment:
            self.configureSimplePayment(with: entity.easyPayProvider)
        case .free:
            self.configureFreeTicket()
        }
    }

    private func configureSimplePayment(with easyPayProvider: String?) {
        guard let easyPayProvider else { return }
        self.paymentMethodView.setData(easyPayProvider)
    }

    private func configurePaymentCardDetail(with paymentCardDetail: PaymentCardDetail?) {
        guard let paymentCardDetail else { return }
        self.paymentMethodView.setData("\(paymentCardDetail.issuer) / \(paymentCardDetail.installmentPlanMonths)")
    }

    private func configureAccountTransferPayment() {
        self.paymentMethodView.setData("계좌이체")
    }

    private func configureFreeTicket() {
        self.depositorInformationStackView.isHidden = true
        self.paymentMethodView.removeFromSuperview()
    }

    private func configureRefundCase(with entity: TicketReservationDetailEntity) {
        switch entity.reservationStatus {
        case .reservationCompleted:
            if Date() <= entity.salesEndTime.formatToDate() && entity.ticketType != .invitation {
                self.requestRefundButton.isHidden = false
                self.changeBlankSpaceViewHeight()
            } else {
                self.requestRefundButton.isHidden = true
            }
            self.refundInformationStackView.isHidden = true
        case .refundCompleted:
            self.requestRefundButton.isHidden = true
            self.refundInformationStackView.isHidden = false
            self.configureRefundInformationStackView(with: entity)
        case .waitingForReceipt:
            return
        }
    }

    private func configureRefundInformationStackView(with entity: TicketReservationDetailEntity) {
        self.totalRefundAmountView.setData("\(entity.totalPaymentAmount)원")

        guard let paymentMethod = entity.paymentMethod else { return }
        switch paymentMethod {
        case .accountTransfer:
            self.refundMethodView.setData("계좌이체")
        case .card:
            guard let paymentCardDetail = entity.paymentCardDetail else { return }
            self.refundMethodView.setData("\(paymentCardDetail.issuer)")
        case .simplePayment:
            guard let easyPayProvider = entity.easyPayProvider else { return }
            self.refundMethodView.setData(easyPayProvider)
        case .free:
            self.refundMethodView.removeFromSuperview()
        }
    }

    private func configureInvitationUI(with entity: TicketReservationDetailEntity) {
        self.paymentMethodView.setData("초청 코드")
        self.depositorInformationStackView.isHidden = true
        self.reversalPolicyView.isHidden = true
        self.requestRefundButton.isHidden = true
    }

    private func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)

        self.scrollView.setContentOffset(bottomOffset, animated: true)
    }

    private func changeBlankSpaceViewHeight() {
        self.blankSpaceView.snp.updateConstraints { make in
            make.height.equalTo(20)
        }
    }

    private func formatPhoneNumber(_ number: String) -> String {

        guard number.count == 11 else {
            return number
        }
        let formattedNumber = "\(number.prefix(3))-\(number.dropFirst(3).prefix(4))-\(number.dropFirst(7))"
        return formattedNumber
    }
}
