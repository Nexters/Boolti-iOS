//
//  TossPaymentViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/20/24.
//

import UIKit

import RxSwift
import TossPayments

final class TossPaymentViewController: UIViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let widget: PaymentWidget
    
    private let orderId: String
    private let selectedTicket: SelectedTicketEntity
    
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
        return button
    }()
    
    // MARK: Initailizer
    
    init(orderId: String,
         selectedTicket: SelectedTicketEntity) {
        self.orderId = orderId
        self.selectedTicket = selectedTicket
        
        self.widget = PaymentWidget(
            clientKey: Environment.TOSS_PAYMENTS_KEY,
            customerKey: orderId
        )
        
        super.init(nibName: nil, bundle: nil)
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
        self.bindInputs()
    }
    
}

// MARK: - Methods

extension TossPaymentViewController {
    
    private func configureTossWidget() {
        let paymentMethods = widget.renderPaymentMethods(amount: PaymentMethodWidget.Amount(value: Double(self.selectedTicket.price * self.selectedTicket.count)))
        let agreement = widget.renderAgreement()
        self.payButton.addTarget(self, action: #selector(requestPayment), for: .touchUpInside)
        
        // set delegate
//        self.widget.delegate = self
//        paymentMethods.widgetStatusDelegate = self
        agreement.agreementUIDelegate = self
        
        self.stackView.addArrangedSubviews([paymentMethods,
                                            agreement,
                                            self.payButton])
    }
    
    @objc func requestPayment() {
        widget.requestPayment(
            info: DefaultWidgetPaymentInfo(
                orderId: self.orderId,
                orderName: "\(self.selectedTicket.ticketName) / \(self.selectedTicket.count)매"))
    }
    
    private func bindInputs() {
        self.navigationBar.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
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
