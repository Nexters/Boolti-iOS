//
//  TicketingDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TicketingDetailViewController: UIViewController {
    
    // MARK: Properties
    
    let viewModel: TicketingDetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationView = BooltiNavigationView(type: .Payment)
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let concertInfoView = ConcertInfoView()
    
    private let ticketHolderInputView = UserInfoInputView(type: .TicketHolder)
    
    private let depositorInputView = UserInfoInputView(type: .Depositor)
    
    private let ticketInfoView = TicketInfoView()
    
    private let paymentMethodView = PaymentMethodView()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        return view
    }()
    
    // MARK: Init
    
    init(viewModel: TicketingDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        
        // 확인용
        concertInfoView.setData(posterURL: "", title: "2024 TOGETHER LUCKY CLUB", datetime: "2024.03.09 (토) 17:00")
    }
}

// MARK: - UI

extension TicketingDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationView, self.scrollView])
        self.scrollView.addSubviews([self.stackView])
        self.stackView.addArrangedSubviews([self.concertInfoView, self.ticketHolderInputView, self.depositorInputView, self.ticketInfoView, self.paymentMethodView])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        }
    }
}
