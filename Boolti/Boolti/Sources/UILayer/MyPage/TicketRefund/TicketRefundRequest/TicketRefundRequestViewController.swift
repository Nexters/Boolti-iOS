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
import RxGesture
import RxKeyboard

final class TicketRefundRequestViewController: BooltiViewController {

    typealias ReservationID = String
    typealias ReasonText = String

    private let ticketRefundConfirmViewControllerFactory: (ReservationID, ReasonText, RefundAccountInformation) -> TicketRefundConfirmViewController

    private let viewModel: TicketRefundRequestViewModel
    private let disposeBag = DisposeBag()

    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "취소 요청하기"))

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

    private let concertInformationView = ConcertInformationView()

    // 환불 정보
    private lazy var refundInformationTitlelabel = self.makeTitleLabel(title: "환불 정보")
    private let refundAmountView = ReservationHorizontalStackView(title: "환불 예정 금액", alignment: .right)
    private let refundMethodView = ReservationHorizontalStackView(title: "환불 수단", alignment: .right)

    private lazy var refundInformationStackView = self.makeContentStackView([
        self.refundInformationTitlelabel,
        self.refundAmountView,
        self.refundMethodView
    ])

    // 취소/환불 규정
    private lazy var reversalPolicyTitlelabel = self.makeTitleLabel(title: "취소/환불 규정")
    // Remote Config로 넘어갈 예정
    private let reversalPolicyLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        label.text = """
        • 티켓 판매 기간 내 발권 취소 및 환불은 서비스 내 처리가 가능하며, 판매 기간 이후에는 주최자에게 직접 연락 바랍니다.
        • 티켓 판매 기간 내 환불 신청은 발권 후 마이 > 예매 내역 > 예매 상세에서 가능합니다.
        • 계좌 이체를 통한 환불은 환불 계좌 정보가 필요하며 영업일 기준 약 1~2일이 소요됩니다.
        • 환불 수수료는 부과되지 않습니다.
        • 기타 사항은 카카오톡 채널 @스튜디오불티로 문의 부탁드립니다.
        """
        label.numberOfLines = 0
        label.setHeadIndent()
        label.font = .body1
        label.textColor = .grey50
        return label
    }()
    private let reversalPolicyConfirmButton = ReversalPolicyConfirmButton()

    private lazy var reversalPolicyStackView = self.makeContentStackView([
        self.reversalPolicyTitlelabel,
        self.reversalPolicyLabel,
        self.reversalPolicyConfirmButton
    ])

    private let requestRefundButton = BooltiButton(title: "취소 요청하기")

    private let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black100.withAlphaComponent(0.85)
        view.isHidden = true

        return view
    }()

    init(
        ticketRefundConfirmViewControllerFactory: @escaping (ReservationID, ReasonText, RefundAccountInformation) -> TicketRefundConfirmViewController,
        viewModel: TicketRefundRequestViewModel
    ) {
        self.ticketRefundConfirmViewControllerFactory = ticketRefundConfirmViewControllerFactory
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
        self.bindUIComponents()
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.requestRefundButton.isEnabled = false

        self.view.addSubviews([
            self.navigationBar,
            self.scrollView,
            self.dimmedBackgroundView
        ])

        self.scrollView.addSubview(self.contentStackView)

        self.configureConstraints()
        self.contentStackView.addArrangedSubviews([
            self.concertInformationView,
            self.refundInformationStackView,
            self.reversalPolicyStackView,
            self.requestRefundButton,
        ])
    }

    private func configureConstraints() {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        let screenWidth = window.screen.bounds.width

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.bottom.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        [
            self.concertInformationView,
            self.reversalPolicyStackView
        ].forEach {
            $0.snp.makeConstraints { make in make.width.equalTo(screenWidth)}
        }

        self.requestRefundButton.snp.makeConstraints { make in
            make.width.equalTo(screenWidth-40)
        }
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

        self.scrollView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {
        self.viewModel.output.tickerReservationDetail
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, entity in
                owner.concertInformationView.setData(
                    posterImageURLPath: entity.concertPosterImageURLPath,
                    concertTitle: entity.concertTitle,
                    salesTicketName: entity.salesTicketName,
                    ticketCount: "\(entity.ticketCount)"
                )
                owner.configureRefundInformation(with: entity)
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.isReversalPolicyChecked
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, isChecked in
                owner.requestRefundButton.isEnabled = isChecked
            }
            .disposed(by: self.disposeBag)
    }

    private func bindUIComponents() {
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(with: self) { owner, keyBoardHeight in
                let height = owner.view.bounds.height

                if keyBoardHeight == 0 {
                    owner.view.frame.origin.y = 0
                } else {
                    owner.view.frame.origin.y -= (keyBoardHeight - height + 650)
                }
            }
            .disposed(by: self.disposeBag)

        self.reversalPolicyConfirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.reversalPolicyConfirmButton.isSelected.toggle()
                owner.viewModel.input.isReversalPolicyChecked.accept(owner.reversalPolicyConfirmButton.isSelected)
            }
            .disposed(by: self.disposeBag)

        self.requestRefundButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let reservationDetail = owner.viewModel.output.tickerReservationDetail.value else { return }
                let refundAccountInformation = RefundAccountInformation(
                    refundMethod: owner.refundMethodView.contentLabel.text,
                    totalRefundAmount: reservationDetail.totalPaymentAmount
                )
                let viewController = owner.ticketRefundConfirmViewControllerFactory(
                    owner.viewModel.reservationID,
                    owner.viewModel.reasonText,
                    refundAccountInformation
                )
                viewController.modalPresentationStyle = .overCurrentContext
                owner.definesPresentationContext = true
                owner.present(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)

        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func configureRefundInformation(with entity: TicketReservationDetailEntity) {
        self.refundAmountView.setData("\(entity.totalPaymentAmount)원")

        guard let paymentMethod = entity.paymentMethod else { return }
        switch paymentMethod {
        case .accountTransfer:
            self.refundMethodView.setData("계좌이체")
        case .card:
            guard let paymentCardDetail = entity.paymentCardDetail else { return }
            self.refundMethodView.setData(paymentCardDetail.issuer)
        case .free:
            self.refundMethodView.removeFromSuperview()
        case .simplePayment:
            guard let easyPayProvider = entity.easyPayProvider else { return }
            self.refundMethodView.setData(easyPayProvider)
        }
    }

    private func makeTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .subhead2
        label.textColor = .grey10

        return label
    }

    private func makeContentStackView(_ subViews: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .grey90
        stackView.isLayoutMarginsRelativeArrangement = true

        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        stackView.addArrangedSubviews(subViews)
        stackView.spacing = 16
        stackView.setCustomSpacing(20, after: subViews[0])

        return stackView
    }
}
