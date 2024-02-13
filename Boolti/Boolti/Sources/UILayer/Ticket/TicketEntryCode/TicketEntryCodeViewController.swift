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
            .bind(with: self, onNext: { owner, _ in
                let inputEntryCode = owner.entryCodeInputView.textFieldText.value
                print(inputEntryCode)
                owner.viewModel.input.didCheckButtonTapEvent.onNext(inputEntryCode)
            })
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {

        self.viewModel.output.isValidEntryCode
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isValid in
                if isValid {
                    // dismiss하고 토스트 이미지 띄우기
                    guard let homeTabBarController = owner.presentingViewController as? HomeTabBarController else { return }
                    guard let rootviewController = homeTabBarController.children[1] as? UINavigationController else { return }
                    guard let ticketDetailViewController = rootviewController.viewControllers.filter({ $0 is TicketDetailViewController
                    })[0] as? TicketDetailViewController else { return }

                    owner.dismiss(animated: true) {
                        ticketDetailViewController.showToast(message: "입장을 확인했어요")
                    }
                } else {
                    // 올바른 입장 코드를 입력해 주세요.
                    owner.entryCodeInputView.isInvalidEntryCodeTyped = false
                }
            }
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
            .skip(1)
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
