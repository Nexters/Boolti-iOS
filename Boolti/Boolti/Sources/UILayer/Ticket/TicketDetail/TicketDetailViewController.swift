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
        scrollView.backgroundColor = .red

        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill

        return stackView
    }()

    private let blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow

        return view
    }()

    private let redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red

        return view
    }()

    private let greenView: UIView = {
        let view = UIView()
        view.backgroundColor = .green

        return view
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

        self.blueView.snp.makeConstraints { make in
            make.height.equalTo(500)
            make.width.equalTo(800)
        }

        self.greenView.snp.makeConstraints { make in
            make.height.equalTo(500)
            make.width.equalTo(800)
        }

        self.redView.snp.makeConstraints { make in
            make.height.equalTo(500)
            make.width.equalTo(800)
        }

        self.contentStackView.addArrangedSubviews([
            self.blueView,
            self.greenView,
            self.ticketDetailView,
            self.redView,
        ])
    }
}
