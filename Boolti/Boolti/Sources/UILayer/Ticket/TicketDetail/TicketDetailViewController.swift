//
//  TicketDetailViewController.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

import RxSwift
import RxCocoa

class TicketDetailViewController: UIViewController {
    
    private let viewModel: TicketDetailViewModel
    private let ticketItem: TicketItem

    private let navigationBar = BooltiNavigationView(type: .ticketDetail)

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
    private let seperatingBlankView = UIView()
    private let reversalPolicyView = ReversalPolicyView()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUIComponenets()
        self.bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(ticketItem: TicketItem, viewModel: TicketDetailViewModel) {
        self.ticketItem = ticketItem
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    private func configureUI() {
        self.view.backgroundColor = .black
        self.view.addSubviews([self.navigationBar, self.scrollView])
        self.scrollView.addSubview(self.contentStackView)

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(25)
        }

        self.seperatingBlankView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }

        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        self.contentStackView.addArrangedSubviews([
            self.ticketDetailView,
            self.seperatingBlankView,
            self.reversalPolicyView
        ])
    }

    private func bindUIComponenets() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {

    }
}
