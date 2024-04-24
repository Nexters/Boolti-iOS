//
//  TicketingCompletionViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit

import RxSwift

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
        self.bindInput()
        self.bindOutput()
        self.setData()
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
        return stackView
    }
    
    private func makeInfoGroupStackView(with stackViews: [UIStackView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubviews(stackViews)
        return stackView
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
    }
    
    private func setData() {
        let data = self.viewModel.ticketingData
        self.ticketHolderInfoLabel.text = "\(data.ticketHolder.name) / \(data.ticketHolder.phoneNumber.formatPhoneNumber())"
        
        if data.selectedTicket.price == 0 {
            self.payerStackView.isHidden = true
        } else {
            self.payerInfoLabel.text = "\(data.depositor?.name ?? "") / \(data.depositor?.phoneNumber.formatPhoneNumber() ?? "")"
        }
        
        self.ticketInfoLabel.text = "\(data.selectedTicket.ticketName) / \(data.selectedTicket.count)매"
        
        self.reservedTicketView.setData(concert: data.concert, selectedTicket: data.selectedTicket)
    }
    
    private func bindOutput() {
        self.viewModel.output.csReservationId
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, id in
                owner.reservationInfoLabel.text = id
            }
            .disposed(by: self.disposeBag)
        
        Observable.combineLatest(self.viewModel.output.bankName,
                                 self.viewModel.output.installmentPlanMonths)
        .map { ($0, $1) }
        .asDriver(onErrorJustReturn: ("", -1))
        .drive(with: self) { owner, payData in
            let ticket = self.viewModel.ticketingData.selectedTicket
            if ticket.ticketType == .invitation {
                self.amountInfoLabel.text = "0원 (초청 코드)"
            } else {
                let amount = ticket.price * ticket.count
                let paymentMonty: String = payData.1 == 0 ? "일시불" : "\(payData.1)개월"
                self.amountInfoLabel.text = "\(amount.formattedCurrency())원\n(\(payData.0) / \(paymentMonty))"
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
