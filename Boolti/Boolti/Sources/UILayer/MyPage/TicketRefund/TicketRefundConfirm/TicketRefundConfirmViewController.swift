//
//  TicketRefundConfirmViewController.swift
//  Boolti
//
//  Created by Miro on 2/14/24.
//

import UIKit

final class TicketRefundConfirmViewController: BooltiViewController {

    private let viewModel: TicketRefundConfirmViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }

    init(viewModel: TicketRefundConfirmViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
