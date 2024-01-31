//
//  TicketingCompletionViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit
import RxSwift

final class TicketingCompletionViewController: UIViewController {
    
    // MARK: Properties
    
    let viewModel: TicketingCompletionViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: TicketingCompletionViewModel) {
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
