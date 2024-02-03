//
//  ConcertDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import UIKit
import RxSwift

final class ConcertDetailViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: ConcertDetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: ConcertDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
