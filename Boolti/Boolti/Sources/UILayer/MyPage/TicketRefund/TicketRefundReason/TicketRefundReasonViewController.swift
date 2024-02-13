//
//  TicketRefundReasonViewController.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

class TicketRefundReasonViewController: BooltiViewController {

    private let viewModel: TicketRefundReasonViewModel

    private let navigationBar = BooltiNavigationBar(type: .defaultUI(backButtonTitle: "환불 요청하기"))

    init(viewModel: TicketRefundReasonViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureConstraints()
    }

    private func configureUI() {
        self.view.addSubviews([
            self.navigationBar
        ])
        self.view.backgroundColor = .grey95
    }

    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}
