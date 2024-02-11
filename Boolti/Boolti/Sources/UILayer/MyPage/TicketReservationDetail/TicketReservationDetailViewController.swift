//
//  TicketReservationDetailViewController.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import UIKit

import RxSwift
import RxAppState
import RxCocoa

final class TicketReservationDetailViewController: BooltiViewController {

    private let viewModel: TicketReservationDetailViewModel
    private let disposeBag = DisposeBag()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.showsVerticalScrollIndicator = false

        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading

        return stackView
    }()

    private let reservationIDLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 0))
        label.textColor = .grey50
        label.font = .pretendardR(14)

        return label
    }()

    init(viewModel: TicketReservationDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    private let navigationBar = BooltiNavigationBar(type: .ticketReservationDetail)

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .red
        self.navigationController?.navigationBar.isHidden = true

        self.view.addSubviews([
            self.navigationBar,
            self.scrollView
        ])

        self.scrollView.addSubview(self.contentStackView)
    }

    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(50)
            make.bottom.horizontalEdges.equalToSuperview()
        }

        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
