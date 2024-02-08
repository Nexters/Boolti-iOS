//
//  LogoutViewController.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import UIKit

final class LogoutViewController: BooltiViewController {

    private let viewModel: LogoutViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init(viewModel: LogoutViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
