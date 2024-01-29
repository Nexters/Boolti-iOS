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
        self.configureScrollViewContentSize()
        
        // 확인용
        concertInfoView.setData(posterURL: "", title: "2024 TOGETHER LUCKY CLUB", datetime: "2024.03.09 (토) 17:00")
    }
}

// MARK: - UI

extension TicketingDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationView, self.scrollView])
        self.scrollView.addSubviews([self.concertInfoView, self.ticketHolderInputView, self.depositorInputView, self.ticketInfoView])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.concertInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        }
        
        self.ticketHolderInputView.snp.makeConstraints { make in
            make.top.equalTo(self.concertInfoView.snp.bottom)
            make.width.equalTo(self.scrollView)
        }
        
        self.depositorInputView.snp.makeConstraints { make in
            make.top.equalTo(self.ticketHolderInputView.snp.bottom).offset(12)
            make.width.equalTo(self.scrollView)
        }
        
        self.ticketInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.depositorInputView.snp.bottom).offset(12)
            make.width.equalTo(self.scrollView)
        }
    }
    
    private func configureScrollViewContentSize() {
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                             height: UIScreen.main.bounds.height - self.navigationView.bounds.height)
    }
}
