//
//  ConcertDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import UIKit
import RxSwift

final class ConcertDetailViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: ConcertDetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationView = BooltiNavigationView(type: .concertDetail)
    
    private let concertPosterView = ConcertPosterView()
    
    private let ticketingPeriodView = TicketingPeriodView()
    
    // MARK: Init
    
    init(viewModel: ConcertDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .grey95
        
        self.configureUI()
        self.configureConstraints()
        
        // 확인용
        self.concertPosterView.setData(images: [.mockPoster, .mockPoster], title: "2024 TOGETHER LUCKY CLUB")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - UI

extension ConcertDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationView,
                               self.concertPosterView,
                               self.ticketingPeriodView])
    }
    
    private func configureConstraints() {
        self.navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.concertPosterView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        self.ticketingPeriodView.snp.makeConstraints { make in
            make.top.equalTo(self.concertPosterView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
