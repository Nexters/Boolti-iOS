//
//  TicketReservationDetailViewController.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import UIKit

final class TicketReservationDetailViewController: BooltiViewController {

    private let viewModel: TicketReservationDetailViewModel

    init(viewModel: TicketReservationDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .red
        self.navigationController?.navigationBar.isHidden = true
    }
}
