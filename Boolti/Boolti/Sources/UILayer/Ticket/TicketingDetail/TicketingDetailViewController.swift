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
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
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
    }
}

// MARK: - UI

extension TicketingDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.scrollView])
    }
    
    private func configureConstraints() {
        
    }
}
