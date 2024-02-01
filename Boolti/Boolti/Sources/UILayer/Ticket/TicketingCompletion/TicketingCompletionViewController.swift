//
//  TicketingCompletionViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit
import RxSwift

final class TicketingCompletionViewController: UIViewController {
    
    // MARK: Properties
    
    let viewModel: TicketingCompletionViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationView = BooltiNavigationView(type: .ticketingCompletion)
    
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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindOutput()
        self.configureUI()
        self.configureConstraints()
        self.bindInput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK: - Methods

extension TicketingCompletionViewController {
    
    private func bindInput() {
        self.navigationView.didHomeButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationView.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.copyButton.rx.tap
            .bind(to: self.viewModel.input.didCopyButtonTap)
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutput() {
        self.viewModel.output.ticketingData
            .take(1)
            .bind(with: self) { owner, data in
                guard let selectedTicket = data.selectedTicket.first else { return }
                if selectedTicket.price == 0 {
                    self.topContentView = self.paymentCompletionView
                    [self.depositDetailView, self.copyButton].forEach { $0.isHidden = true }
                } else {
                    self.topContentView = self.depositSummaryView
                }
                
                // TODO: 공연 이름도 가져와야함! entity 수정필요
                self.depositSummaryView.setData(date: Date(), price: selectedTicket.price)
                self.reservedTicketView.setData(concert: "2024 TOGETHER LUCKY CLUB", selectedTicket: selectedTicket)
                self.depositDetailView.setData(depositDeadline: Date())
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension TicketingCompletionViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationView,
                               self.topContentView,
                               self.underlineView,
                               self.reservedTicketView,
                               self.depositDetailView,
                               self.copyButton])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        
        self.navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.topContentView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
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
