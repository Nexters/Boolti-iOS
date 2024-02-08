//
//  TicketReservationsViewController.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import UIKit

final class TicketReservationsViewController: BooltiViewController {

    private let viewModel: TicketReservationsViewModel

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    init(viewModel: TicketReservationsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
