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
    
    var onDismissOrderSuccess: ((TicketingEntity) -> ())?
    var onDismissOrderFailure: (() -> ())?
    
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
            customerKey: self.viewModel.ticketingEntity.orderId ?? ""
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
        let selectedTicket = self.viewModel.ticketingEntity.selectedTicket
        let paymentMethods = widget.renderPaymentMethods(amount: PaymentMethodWidget.Amount(value: Double(selectedTicket.price * selectedTicket.count)))
        let agreement = widget.renderAgreement()
        self.payButton.addTarget(self, action: #selector(requestPayment), for: .touchUpInside)
        
        self.widget.delegate = self
        paymentMethods.widgetStatusDelegate = self
        agreement.agreementUIDelegate = self
        
        self.stackView.addArrangedSubviews([paymentMethods,
                                            agreement,
                                            self.payButton])
    }
    
    @objc func requestPayment() {
        guard let orderId = self.viewModel.ticketingEntity.orderId else { return }
        let selectedTicket = self.viewModel.ticketingEntity.selectedTicket
        widget.requestPayment(
            info: DefaultWidgetPaymentInfo(
                orderId: orderId,
                orderName: "\(selectedTicket.ticketName) / \(selectedTicket.count)매"))
    }
    
    private func bindInput() {
        self.navigationBar.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutput() {
        self.viewModel.output.didOrderPaymentCompleted
            .bind(with: self) { owner, ticketingEntity in
                owner.dismiss(animated: true) {
                    owner.onDismissOrderSuccess?(ticketingEntity)
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
            self.onDismissOrderFailure?()
        }
    }
    
}

// MARK: - TossPaymentsWidgetStatusDelegate

extension TossPaymentViewController: TossPaymentsWidgetStatusDelegate {
    
    func didReceivedLoad(_ name: String) {
        self.payButton.isHidden = false
    }
    
    func didReceiveFail(_ name: String, fail: TossPaymentsResult.Fail) {
        self.showToast(message: "결제 정보를 입력해주세요")
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
