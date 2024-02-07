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
        self.bindViewModel()
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

    private func bindViewModel() {
        self.bindInputs()
        self.bindOutputs()
    }

    private func bindInputs() {

        self.entryCodeInputView.didCheckButtonTap
            .do(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .bind(to: self.viewModel.input.didCheckButtonTapEvent)
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {
        self.viewModel.output.isValidEntryCode
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isValid in
                if isValid {
                    // dismiss하고 토스트 이미지 띄우기
                } else {
                    print("뭔데...")
                    // 올바른 입장 코드를 입력해 주세요.
                    owner.entryCodeInputView.showErrorComments()
                }
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
                if text == "" {
                    owner.entryCodeInputView.enableCheckButton.accept(false)
                } else {
                    owner.entryCodeInputView.enableCheckButton.accept(true)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
