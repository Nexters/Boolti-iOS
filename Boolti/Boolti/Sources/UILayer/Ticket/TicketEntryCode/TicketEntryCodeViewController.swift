//
//  TicketEntryCodeViewController.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import UIKit

import RxSwift
import RxCocoa

class TicketEntryCodeViewController: BooltiViewController {

    private let viewModel: TicketEntryCodeViewModel

    private let disposeBag = DisposeBag()

    private let entryCodeInputView = EntryCodeInputView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUIComponents()
    }

    init(viewModel: TicketEntryCodeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .black100.withAlphaComponent(0.85)
        self.view.addSubview(self.entryCodeInputView)

        self.entryCodeInputView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bindUIComponents() {
//        self.entryCodeInputView.textFieldText
//            .asDriver(onErrorJustReturn: "")
//            .drive(with: self) { owner, text in
//                print(text)
//                if text == "" {
//                    owner.entryCodeInputView.disableCheckButton()
//                } else {
//                    owner.entryCodeInputView.enableCheckButton()
//                }
//            }
//            .disposed(by: self.disposeBag)

        self.entryCodeInputView.textFieldText
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                print(text)
                if text == "" {
                    owner.entryCodeInputView.enableCheckButton.onNext(false)
                } else {
                    owner.entryCodeInputView.enableCheckButton.onNext(true)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
