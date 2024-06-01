//
//  TicketEntryCodeViewController.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

final class TicketEntryCodeViewController: BooltiViewController {

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
            make.horizontalEdges.equalToSuperview().inset(32)
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
            .bind(with: self, onNext: { owner, _ in
                let inputEntryCode = owner.entryCodeInputView.textFieldText.value
                owner.viewModel.input.didCheckButtonTapEvent.onNext(inputEntryCode)
            })
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {

        self.viewModel.output.entryCodeResponse
            .asDriver(onErrorJustReturn: .mismatch)
            .drive(with: self, onNext: { owner, response in
                switch response {
                case .valid:
                    guard let detailViewController = owner.presentingViewController as? TicketDetailViewController else { return }

                    owner.dismiss(animated: true) {
                        detailViewController.showToast(message: "사용되었어요")
                        detailViewController.hideEntryCodeButton()
                    }
                default:
                    owner.entryCodeInputView.setData(with: response)
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func bindUIComponents() {

        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(with: self) { owner, keyBoardHeight in
                if keyBoardHeight == 0 {
                    owner.view.frame.origin.y = 0
                } else {
                    owner.view.frame.origin.y -= 50
                }
            }
            .disposed(by: self.disposeBag)

        self.entryCodeInputView.textFieldText
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                owner.entryCodeInputView.enableCheckButton.accept(!text.isEmpty)

                guard !owner.entryCodeInputView.isInvalidEntryCodeTyped else { return }
                owner.entryCodeInputView.isInvalidEntryCodeTyped = true
            }
            .disposed(by: self.disposeBag)

        self.entryCodeInputView.didCloseButtonTap
            .take(1)
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}
