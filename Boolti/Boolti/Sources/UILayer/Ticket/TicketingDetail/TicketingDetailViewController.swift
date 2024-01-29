//
//  TicketingDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit
import RxSwift

final class TicketingDetailViewController: UIViewController {
    
    // MARK: Properties
    
    let viewModel: TicketingDetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationView = BooltiNavigationView(type: .payment)
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let concertInfoView = ConcertInfoView()
    
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
        
        concertInfoView.setData(posterURL: "", title: "2024 TOGETHER LUCKY CLUB", datetime: "2024.03.09 (토) 17:00")
    }
}

// MARK: - UI

extension TicketingDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationView, self.scrollView])
        self.scrollView.addSubviews([self.concertInfoView])
        
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
    }
}
