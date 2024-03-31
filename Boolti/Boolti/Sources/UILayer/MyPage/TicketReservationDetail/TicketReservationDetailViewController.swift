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

    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "예매 내역 상세"))

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

    private let bankNameView = ReservationHorizontalStackView(title: "은행명", alignment: .right)
    private let accountNumberView = ReservationHorizontalStackView(title: "계좌번호", alignment: .right)
    private let accountHolderNameView = ReservationHorizontalStackView(title: "예금주", alignment: .right)
    private let depositDeadLineView = ReservationHorizontalStackView(title: "입금 마감일", alignment: .right)

    private lazy var depositAccountInformationStackView = ReservationCollapsableStackView(
        title: "입금 계좌 정보",
        contentViews: [self.bankNameView, self.accountNumberView, self.accountHolderNameView, self.depositDeadLineView],
        isHidden: false
    )

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
            self.depositAccountInformationStackView,
            self.purchaserInformationStackView,
            self.depositorInformationStackView,
            self.ticketInformationStackView,
            self.paymentInformationStackView,
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
            ticketType: entity.salesTicketName,
            ticketCount: entity.ticketCount
        )

        // 결제 정보
        self.totalPaymentAmountView.setData("\(entity.totalPaymentAmount)원")

        self.configureRefundButton(with: entity)

        // 티켓 정보
        self.ticketTypeView.setData(entity.salesTicketName)
        self.ticketCountView.setData("\(entity.ticketCount)매")

        // 예매자 정보
        self.purchasernNameView.setData(entity.purchaseName)
        self.purchaserPhoneNumberView.setData(entity.purchaserPhoneNumber)

        let ticketType = entity.ticketType

        switch ticketType {
        case .sale:
            self.setAdditionalDataForSale(with: entity)
        case .invitation:
            self.configureInvitationUI(with: entity)
        }
    }

    private func setAdditionalDataForSale(with entity: TicketReservationDetailEntity) {
        let paymentMethod = PaymentMethod(rawValue: entity.paymentMethod)!
        self.paymentMethodView.setData(paymentMethod.description)

        // 입금 계좌 정보
        self.bankNameView.setData(entity.bankName)
        self.accountNumberView.setData(entity.accountNumber, isUnderLined: true)
        self.accountHolderNameView.setData(entity.accountHolderName)
        self.depositDeadLineView.setData(entity.depositDeadLine.formatToDate().format(.dateTime))

        // 입금자 정보
        self.depositorNameView.setData(entity.depositorName)
        self.depositorPhoneNumberView.setData(entity.depositorPhoneNumber)
    }

    private func configureRefundButton(with entity: TicketReservationDetailEntity) {
        switch entity.reservationStatus {
        case .reservationCompleted:
            if Date() <= entity.salesEndTime.formatToDate() {
                self.requestRefundButton.isHidden = false
                self.changeBlankSpaceViewHeight()
            } else {
                self.requestRefundButton.isHidden = true
            }
        default:
            self.requestRefundButton.isHidden = true
        }
    }

    private func configureInvitationUI(with entity: TicketReservationDetailEntity) {
        self.paymentMethodView.setData(entity.paymentMethod)
        self.depositAccountInformationStackView.isHidden = true
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
}
