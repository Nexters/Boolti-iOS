//
//  QRScannerViewController.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import UIKit

import RxSwift

final class QRScannerListViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: QRScannerListViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Init

    init(viewModel: QRScannerListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
    }
}
