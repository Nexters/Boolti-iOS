//
//  TermsAgreementViewController.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import UIKit

class TermsAgreementViewController: UIViewController {

    private let viewModel: TermsAgreementViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue

        // Do any additional setup after loading the view.
    }
    
    init(viewModel: TermsAgreementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
