//
//  TicketingCompletionViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit

import RxSwift
import RxAppState

final class TicketingCompletionViewController: BooltiViewController {
    
    // MARK: Properties
    
    let viewModel: TicketingCompletionViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .ticketingCompletion)
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .aggroM(24)
        label.textColor = .grey05
        label.text = "결제를 완료했어요"
        return label
    }()
    
    private let firstUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        return view
    }()
    
    private lazy var reservationTitleLabel = self.makeLabel(text: "주문 번호")
    private lazy var reservationInfoLabel = self.makeLabel()
    private lazy var reservationStackView = self.makeInfoRowStackView(title: reservationTitleLabel, info: reservationInfoLabel)
    
    private lazy var ticketHolderTitleLabel = self.makeLabel(text: "예매자 정보")
    private lazy var ticketHolderInfoLabel = self.makeLabel()
    private lazy var ticketHolderStackView = self.makeInfoRowStackView(title: ticketHolderTitleLabel, info: ticketHolderInfoLabel)
    
    private lazy var payerTitleLabel = self.makeLabel(text: "결제자 정보")
    private lazy var payerInfoLabel = self.makeLabel()
    private lazy var payerStackView = self.makeInfoRowStackView(title: payerTitleLabel, info: payerInfoLabel)
    
    private lazy var firstInfoStackView = self.makeInfoGroupStackView(with: [reservationStackView, ticketHolderStackView, payerStackView])
    
    private let secondUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        return view
    }()
    
    private lazy var amountTitleLabel = self.makeLabel(text: "결제 금액")
    private lazy var amountInfoLabel = self.makeLabel()
    private lazy var amountStackView = self.makeInfoRowStackView(title: amountTitleLabel, info: amountInfoLabel)
    
    private lazy var ticketTitleLabel = self.makeLabel(text: "주문 티켓")
    private lazy var ticketInfoLabel = self.makeLabel()
    private lazy var ticketStackView = self.makeInfoRowStackView(title: ticketTitleLabel, info: ticketInfoLabel)
    
    private lazy var secondInfoStackView = self.makeInfoGroupStackView(with: [amountStackView, ticketStackView])
    
    private let reservedTicketView = ReservedTicketView()
    
    private let openReservationButton: BooltiButton = {
        let button = BooltiButton(title: "예매 내역보기")
        button.backgroundColor = .grey80
        return button
    }()
    
    private let openTicketButton = BooltiButton(title: "티켓보기")
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        stackView.addArrangedSubviews([self.openReservationButton,
                                       self.openTicketButton])
        return stackView
    }()
    
    // MARK: Init
    
    init(viewModel: TicketingCompletionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureConstraints()
        self.bindComponents()
        self.bindInput()
        self.bindOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK: - Methods

extension TicketingCompletionViewController {
    
    private func makeLabel(text: String? = nil) -> BooltiUILabel {
        let label = BooltiUILabel()
        label.font = .pretendardR(16)
        label.text = text
        label.textColor = text == nil ? .grey15 : .grey30
        label.numberOfLines = 2
        return label
    }
    
    private func makeInfoRowStackView(title: BooltiUILabel, info: BooltiUILabel) -> UIStackView {
        title.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.addArrangedSubviews([title, info])
        stackView.alignment = .top
        return stackView
    }
    
    private func makeInfoGroupStackView(with stackViews: [UIStackView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubviews(stackViews)
        return stackView
    }
    
    private func bindComponents() {
        self.openReservationButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.changeTab(to: .myPage)
                
                UserDefaults.landingDestination = .reservationList
                NotificationCenter.default.post(
                    name: Notification.Name.LandingDestination.reservationList,
                    object: nil
                )
            }
            .disposed(by: self.disposeBag)
        
        self.openTicketButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.changeTab(to: .ticket)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func changeTab(to tab: HomeTab) {
        NotificationCenter.default.post(
            name: Notification.Name.didTabBarSelectedIndexChanged,
            object: nil,
            userInfo: ["tabBarIndex" : tab.rawValue]
        )
    }
    
    private func bindInput() {
        self.navigationBar.didHomeButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationBar.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                guard let viewControllers = self.navigationController?.viewControllers else { return }
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
            .disposed(by: self.disposeBag)

        self.rx.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.viewWillAppearEvent.onNext(())
            }
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {
        self.viewModel.output.reservationDetail
            .take(1)
            .compactMap { $0 }
            .bind(with: self) { owner, entity in
                owner.reservationInfoLabel.text = entity.csReservationID
                owner.ticketHolderInfoLabel.text = "\(entity.purchaseName) / \(entity.purchaserPhoneNumber.formatPhoneNumber())"
                owner.ticketInfoLabel.text = "\(entity.salesTicketName) / \(entity.ticketCount)매"
                owner.reservedTicketView.setData(
                    concertName: entity.concertTitle,
                    concertDate: entity.showDate,
                    posterURL: entity.concertPosterImageURLPath
                )

                switch entity.ticketType {
                case .invitation:
                    owner.configureInvitationTicketCase(with: entity)
                case .sale:
                    owner.configureSaleTicketCases(with: entity)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UI

extension TicketingCompletionViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.titleLabel,
                               self.firstUnderlineView,
                               self.firstInfoStackView,
                               self.secondUnderlineView,
                               self.secondInfoStackView,
                               self.reservedTicketView,
                               self.buttonStackView])
        
        self.view.backgroundColor = .grey95
    }

    private func configureSaleTicketCases(with entity: TicketReservationDetailEntity) {
        guard let paymentMethod = entity.paymentMethod else { return }
        switch paymentMethod {
        case .accountTransfer:
            self.setAccountTransferPaymentTicketCase(with: entity)
        case .card:
            self.setCardPaymentTicketCase(with: entity)
        case .simplePayment:
            self.setSimplePaymentTicketCase(with: entity)
        case .free:
            self.setFreeTicketCase(with: entity)
        }
    }

    private func configureInvitationTicketCase(with entity: TicketReservationDetailEntity) {
        self.amountInfoLabel.text = "0원 (초청 코드)"
        self.payerStackView.isHidden = true
    }

    private func setFreeTicketCase(with entity: TicketReservationDetailEntity) {
        self.amountInfoLabel.text = "0원"
        self.payerStackView.isHidden = true
    }

    private func setCardPaymentTicketCase(with entity: TicketReservationDetailEntity) {
        self.setPayerInfoLabel(with: entity)

        guard let paymentCardDetail = entity.paymentCardDetail else { return }
        let installmentPlanMonths = paymentCardDetail.installmentPlanMonths
        let paymentMonth = installmentPlanMonths == "0" ? "일시불" : "\(installmentPlanMonths)"

        self.amountInfoLabel.text = "\(entity.totalPaymentAmount)원\n(\(paymentCardDetail.issuer) / \(paymentMonth))"
    }

    private func setAccountTransferPaymentTicketCase(with entity: TicketReservationDetailEntity) {
        self.setPayerInfoLabel(with: entity)
        guard let accountTransferBank = entity.accountTransferBank else { return }
        self.amountInfoLabel.text = "\(entity.totalPaymentAmount)원\n(\(accountTransferBank) / 계좌이체)"
    }

    private func setSimplePaymentTicketCase(with entity: TicketReservationDetailEntity) {
        self.setPayerInfoLabel(with: entity)
        guard let easyPayProvider = entity.easyPayProvider else { return }
        self.amountInfoLabel.text = "\(entity.totalPaymentAmount)원\n(\(easyPayProvider) / 간편결제)"
    }

    private func setPayerInfoLabel(with entity: TicketReservationDetailEntity) {
        self.payerInfoLabel.text = "\(entity.depositorName) / \(entity.depositorPhoneNumber.formatPhoneNumber())"
    }

    private func configureConstraints() {

        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.firstUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        self.firstInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(self.firstUnderlineView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.secondUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(self.firstInfoStackView.snp.bottom).offset(25)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        self.secondInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(self.secondUnderlineView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.reservedTicketView.snp.makeConstraints { make in
            make.top.equalTo(self.secondInfoStackView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}
