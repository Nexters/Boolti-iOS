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
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        return view
    }()
    
    private let reservedTicketView = ReservedTicketView()
    
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
    }
    
    private func bindOutput() {
        self.viewModel.ticketingData
            .take(1)
            .bind(with: self) { owner, data in
                owner.reservedTicketView.setData(concert: data.concert, selectedTicket: data.selectedTicket)
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UI

extension TicketingCompletionViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.titleLabel,
                               self.underlineView,
                               self.reservedTicketView])
        
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
        
        self.underlineView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        
        self.reservedTicketView.snp.makeConstraints { make in
            make.top.equalTo(self.underlineView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
}
