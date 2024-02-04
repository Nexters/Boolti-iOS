//
//  TicketDetailViewController.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

class TicketDetailViewController: UIViewController {
    
    private let viewModel: TicketDetailViewModel
    private let ticketItem: TicketItem

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black

        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill

        return stackView
    }()

    private lazy var ticketDetailView = TicketDetailView(item: self.ticketItem)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(ticketItem: TicketItem, viewModel: TicketDetailViewModel) {
        self.ticketItem = ticketItem
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    private func configureUI() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(self.contentStackView)

        self.scrollView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(30)
        }

        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        self.contentStackView.addArrangedSubviews([
            self.ticketDetailView,
        ])
    }
}
