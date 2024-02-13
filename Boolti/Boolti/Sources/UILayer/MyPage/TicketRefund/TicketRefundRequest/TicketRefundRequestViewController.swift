//
//  TicketRefundRequestViewController.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

import RxSwift
import RxAppState
import RxCocoa
import RxGesture
import RxKeyboard

class TicketRefundRequestViewController: BooltiViewController {

    private let viewModel: TicketRefundRequestViewModel
    private let disposeBag = DisposeBag()

    private let navigationBar = BooltiNavigationBar(type: .defaultUI(backButtonTitle: "환불 요청하기"))
    private let concertInformationView = ConcertInformationView()

    private let accountHolderNameView = AccountContentView(
        title: "이름",
        placeHolder: "실명을 입력해 주세요",
        errorComment: "이름을 올바르게 입력해 주세요"
    )
    private let accountHolderPhoneNumberView = AccountContentView(
        title: "연락처",
        placeHolder: "숫자만 입력해 주세요",
        errorComment: "연락처를 올바르게 입력해 주세요"
    )
    private lazy var accountHolderView = ReservationCollapsableStackView(
        title: "예금주 정보",
        contentViews: [self.accountHolderNameView, self.accountHolderPhoneNumberView],
        isHidden: false
    )

    private let refundAccountInformationView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey90

        return view
    }()

    private let refundAccountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "환불 계좌 정보"
        label.font = .subhead2
        label.textColor = .grey10

        return label
    }()

    private let selectRefundBankView = SelectRefundBankView()
    private let refundAccountNumberView = RefundAccountNumberView()

    private let requestRefundButton = BooltiButton(title: "환불 요청하기")

    init(viewModel: TicketRefundRequestViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindViewModel()
        self.bindUIComponents()
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.requestRefundButton.isEnabled = false
        self.accountHolderPhoneNumberView.contentTextField.keyboardType = .phonePad
        self.refundAccountNumberView.accountNumberTextField.keyboardType = .phonePad

        self.refundAccountInformationView.addSubviews([
            self.refundAccountTitleLabel,
            self.selectRefundBankView,
            self.refundAccountNumberView
        ])

        self.view.addSubviews([
            self.navigationBar,
            self.concertInformationView,
            self.accountHolderView,
            self.refundAccountInformationView,
            self.requestRefundButton
        ])

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.concertInformationView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
        }

        self.accountHolderView.snp.makeConstraints { make in
            make.top.equalTo(self.concertInformationView.snp.bottom)
        }

        self.refundAccountInformationView.snp.makeConstraints { make in
            make.height.equalTo(205)
            make.top.equalTo(self.accountHolderView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }

        self.refundAccountTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
        }

        self.selectRefundBankView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(self.refundAccountTitleLabel.snp.bottom).offset(20)
        }

        self.refundAccountNumberView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(self.selectRefundBankView.snp.bottom).offset(12)
        }

        self.requestRefundButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
        }

        self.configureAccountHolderViewSpacing()
    }

    private func configureAccountHolderViewSpacing() {
        let subview = self.accountHolderView.arrangedSubviews[1]
        self.accountHolderView.setCustomSpacing(16, after: subview)
    }

    private func bindViewModel() {
        self.bindInputs()
        self.bindOutputs()
    }

    private func bindInputs() {
        self.rx.viewWillAppear
            .asDriver(onErrorJustReturn: true)
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.input.viewWillAppearEvent.accept(())
            })
            .disposed(by: self.disposeBag)

        self.selectRefundBankView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                let viewController = TicketRefundBankSelectionViewController()

                viewController.selectedItem = { item in
                    owner.selectRefundBankView.setData(with: item.bankName)
                }

                self.present(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {
        self.viewModel.output.tickerReservationDetail
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, entity in
                owner.concertInformationView.setData(
                    posterImageURLPath: entity.concertPosterImageURLPath,
                    concertTitle: entity.concertTitle,
                    ticketType: entity.ticketType,
                    ticketCount: entity.ticketCount
                )
            }
            .disposed(by: self.disposeBag)
    }

    private func bindUIComponents() {
        RxKeyboard.instance.visibleHeight
            .skip(1)
            .drive(with: self) { owner, keyBoardHeight in
                let height = owner.view.bounds.height

                if keyBoardHeight == 0 {
                    owner.view.frame.origin.y = 0
                } else {
                    owner.view.frame.origin.y -= (keyBoardHeight - height + 620)
                }
            }
            .disposed(by: self.disposeBag)

        self.accountHolderNameView.contentTextField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                guard let text = owner.accountHolderNameView.contentTextField.text else { return }
                    owner.accountHolderNameView.isValidTextTyped = owner.checkName(text)
            })
            .disposed(by: self.disposeBag)

        self.accountHolderPhoneNumberView.contentTextField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                guard let text = owner.accountHolderPhoneNumberView.contentTextField.text else { return }
                owner.accountHolderPhoneNumberView.isValidTextTyped = owner.checkPhoneNumber(text)
            })
            .disposed(by: self.disposeBag)

        self.refundAccountNumberView.accountNumberTextField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(with: self) { owner, _ in
                guard let text = owner.refundAccountNumberView.accountNumberTextField.text else { return }
                var isValid = owner.checkAccountNumber(text)
                owner.refundAccountNumberView.isValidTextTyped = isValid
            }
            .disposed(by: self.disposeBag)
    }

    private func checkName(_ text: String) -> Bool {
        let koreanPattern = "^[가-힣]*$"
        return text.range(of: koreanPattern, options: .regularExpression) != nil
    }

    private func checkPhoneNumber(_ text: String) -> Bool {
        guard text.hasPrefix("010") else { return false }
        return true
    }

    private func checkAccountNumber(_ text: String) -> Bool {
        let phoneNumberPattern = #"^\d{11,13}$"#
        return text.range(of: phoneNumberPattern, options: .regularExpression) != nil
    }
}
