//
//  LoginViewController.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import UIKit

class LoginViewController: UIViewController {

    private let viewModel: LoginViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGray
        print("View")
    }

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
