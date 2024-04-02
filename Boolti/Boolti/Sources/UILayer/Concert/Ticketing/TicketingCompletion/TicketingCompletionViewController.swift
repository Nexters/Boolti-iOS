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
    
    private var topContentView = UIView()
    
    private let depositSummaryView = DepositSummaryView()
    
    private let paymentCompletionView = PaymentCompletionView()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        return view
    }()
    
    private let reservedTicketView = ReservedTicketView()
    
    private let depositDetailView = DepositDetailView()
    
    private let copyButton: BooltiButton = {
        let button = BooltiButton(title: "계좌번호 복사하기")
        button.backgroundColor = .grey20
        button.setTitleColor(.grey90, for: .normal)
        return button
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
        
        self.configureToastView(isButtonExisted: false)
        self.bindOutput()
        self.configureUI()
        self.configureConstraints()
        self.bindInput()
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
        
        self.copyButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didCopyButtonTap.onNext(())
                owner.showToast(message: "계좌번호가 복사되었어요")
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutput() {
        self.viewModel.ticketingData
            .take(1)
            .bind(with: self) { owner, data in
                if data.selectedTicket.price == 0 {
                    self.topContentView = self.paymentCompletionView
                    [self.depositDetailView, self.copyButton].forEach { $0.isHidden = true }
                } else {
                    self.topContentView = self.depositSummaryView
                }
                
                self.depositSummaryView.setData(date: data.concert.salesEndTime, price: data.selectedTicket.count * data.selectedTicket.price)
                self.reservedTicketView.setData(concert: data.concert, selectedTicket: data.selectedTicket)
                self.depositDetailView.setSalesEndTime(salesEndTime: data.concert.salesEndTime)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.reservationDetail
            .take(1)
            .bind(with: self) { owner, data in
                self.depositDetailView.setBankData(reservation: data)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension TicketingCompletionViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.topContentView,
                               self.underlineView,
                               self.reservedTicketView,
                               self.depositDetailView,
                               self.copyButton])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.topContentView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.underlineView.snp.makeConstraints { make in
            make.top.equalTo(self.topContentView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        self.reservedTicketView.snp.makeConstraints { make in
            make.top.equalTo(self.underlineView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.depositDetailView.snp.makeConstraints { make in
            make.top.equalTo(self.reservedTicketView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.copyButton.snp.makeConstraints { make in
            make.top.equalTo(self.depositDetailView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
