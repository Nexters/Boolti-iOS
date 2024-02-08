//
//  TicketEntryCodeViewController.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import UIKit

class TicketEntryCodeViewController: UIViewController {

    private let viewModel: TicketEntryCodeViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black100.withAlphaComponent(0.85)
    }

    init(viewModel: TicketEntryCodeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
