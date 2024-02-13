//
//  TicketRefundRequestViewController.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

import RxSwift
import RxAppState
import RxCocoa

class TicketRefundRequestViewController: UIViewController {

    private let viewModel: TicketRefundRequestViewModel
    private let disposeBag = DisposeBag()

    private let navigationBar = BooltiNavigationBar(type: .defaultUI(backButtonTitle: "환불 요청하기"))
    private let concertInformationView = ConcertInformationView()

    private let accountHolderNameView = RefundHorizontalStackView(title: "이름")
    private let accountHolderPhoneNumberView = RefundHorizontalStackView(title: "연락처")
    private lazy var accountHolderView = ReservationCollapsableStackView(
        title: "예금주 정보",
        contentViews: [self.accountHolderNameView, self.accountHolderPhoneNumberView],
        isHidden: false
    )

    init(viewModel: TicketRefundRequestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95

        self.view.addSubviews([
            self.navigationBar,
            self.concertInformationView,
            self.accountHolderView
        ])

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.concertInformationView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
        }

        self.accountHolderView.snp.makeConstraints { make in
            make.top.equalTo(self.concertInformationView.snp.bottom)
        }

        self.configureAccountHolderViewSpacing()
    }

    private func configureAccountHolderViewSpacing() {
        let subview = self.accountHolderView.arrangedSubviews[1]
        self.accountHolderView.setCustomSpacing(16, after: subview)
    }
}
