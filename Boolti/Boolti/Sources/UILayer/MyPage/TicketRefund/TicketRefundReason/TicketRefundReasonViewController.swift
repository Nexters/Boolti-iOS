//
//  TicketRefundReasonViewController.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

class TicketRefundReasonViewController: BooltiViewController {

    private let viewModel: TicketRefundReasonViewModel

    init(viewModel: TicketRefundReasonViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
