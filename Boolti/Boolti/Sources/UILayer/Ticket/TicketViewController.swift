//
//  TicketViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class TicketViewController: ViewController {

    private let disposeBag = DisposeBag()
//    private var viewModel: TicketViewModel?
    private let viewModel = TicketViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: 화면 넘어가는 거 확인용. 나중에 지워야함!
        self.view.backgroundColor = .green
        self.bind()
        self.viewModel.startLoading()
    }

    private func bind() {
        self.viewModel.isLoading
            .distinctUntilChanged()
            .bind(to: self.isLoading)
            .disposed(by: self.disposeBag)
    }
}
