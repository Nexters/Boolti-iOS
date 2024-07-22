//
//  TossPaymentViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/20/24.
//

import UIKit

import RxSwift
import TossPayments

final class TossPaymentViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: TossPaymentsViewModel
    private let disposeBag = DisposeBag()
    private let widget: PaymentWidget
    
    var onDismissOrderSuccess: ((Int) -> ())?
    var onDismissOrderFailure: ((TicketingErrorType) -> ())?
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .tossPaymentsWidget)
    
    private lazy var paymentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubviews([self.stackView])
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    private let payButton: UIButton = {
        let button = UIButton()
        button.setTitle("결제하기", for: .normal)
        button.titleLabel?.font = .subhead1
        button.titleLabel?.textColor = .grey05
        button.backgroundColor = .toss
        button.layer.cornerRadius = 4
        button.isHidden = true
        return button
    }()
    
    // MARK: Initailizer
    
    init(viewModel: TossPaymentsViewModel) {
        self.viewModel = viewModel
        
        self.widget = PaymentWidget(
            clientKey: Environment.TOSS_PAYMENTS_KEY,
            customerKey: "user-\(UserDefaults.userId)"
        )
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTossWidget()
        self.configureUI()
        self.configureConstraints()
        self.bindInput()
        self.bindOutput()
    }
    
}

// MARK: - Methods

extension TossPaymentViewController {
    
    private func configureTossWidget() {
        var selectedTicket: SelectedTicketEntity
        
        switch self.viewModel.type {
        case .ticketing:
            guard let ticketingEntity = self.viewModel.ticketingEntity else { return }
            selectedTicket = ticketingEntity.selectedTicket
        case .gifting:
            guard let giftingEntity = self.viewModel.giftingEntity else { return }
            selectedTicket = giftingEntity.selectedTicket
        }

        let paymentMethods = widget.renderPaymentMethods(amount: PaymentMethodWidget.Amount(value: Double(selectedTicket.price * selectedTicket.count)))
        let agreement = widget.renderAgreement()
        
        self.widget.delegate = self
        paymentMethods.widgetStatusDelegate = self
        agreement.agreementUIDelegate = self
        
        self.stackView.addArrangedSubviews([paymentMethods,
                                            agreement,
                                            self.payButton])
    }
    
    private func bindInput() {
        self.navigationBar.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.payButton.rx.tap
            .bind(with: self) { owner, _ in
                var selectedTicket: SelectedTicketEntity
                var orderId: String
                
                switch self.viewModel.type {
                case .ticketing:
                    guard let ticketingEntity = self.viewModel.ticketingEntity else { return }
                    selectedTicket = ticketingEntity.selectedTicket
                    guard let id = ticketingEntity.orderId else { return }
                    orderId = id
                case .gifting:
                    guard let giftingEntity = self.viewModel.giftingEntity else { return }
                    selectedTicket = giftingEntity.selectedTicket
                    guard let id = giftingEntity.orderId else { return }
                    orderId = id
                }

                owner.widget.requestPayment(
                    info: DefaultWidgetPaymentInfo(
                        orderId: orderId,
                        orderName: "\(selectedTicket.ticketName) / \(selectedTicket.count)매"))
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutput() {
        self.viewModel.output.didOrderPaymentCompleted
            .bind(with: self) { owner, id in
                owner.dismiss(animated: true) {
                    owner.onDismissOrderSuccess?(id)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.didOrderPaymentFailed
            .bind(with: self) { owner, error in
                owner.dismiss(animated: true) {
                    owner.onDismissOrderFailure?(error)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - TossPaymentsDelegate

extension TossPaymentViewController: TossPaymentsDelegate {
    
    func handleSuccessResult(_ success: TossPaymentsResult.Success) {
        self.viewModel.input.successResult.accept(success)
    }
    
    func handleFailResult(_ fail: TossPaymentsResult.Fail) {
        self.dismiss(animated: true) {
            self.onDismissOrderFailure?(.tossError)
        }
    }
    
}

// MARK: - TossPaymentsWidgetStatusDelegate

extension TossPaymentViewController: TossPaymentsWidgetStatusDelegate {
    
    func didReceivedLoad(_ name: String) {
        self.payButton.isHidden = false
    }
    
}

// MARK: - TossPaymentsWidgetStatusDelegate

extension TossPaymentViewController: TossPaymentsAgreementUIDelegate {
    
    func didUpdateAgreementStatus(_ widget: AgreementWidget, agreementStatus: AgreementStatus) {
        self.payButton.isEnabled = agreementStatus.agreedRequiredTerms
        self.payButton.backgroundColor = agreementStatus.agreedRequiredTerms ? .toss : .grey10
    }
    
}

// MARK: - UI

extension TossPaymentViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubviews([self.navigationBar,
                               self.paymentScrollView])
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.paymentScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        self.stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.paymentScrollView)
            make.width.equalTo(self.paymentScrollView)
        }
        
        self.payButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.horizontalEdges.equalTo(self.stackView).inset(20)
        }
    }
    
}
