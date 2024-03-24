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

final class TicketRefundRequestViewController: BooltiViewController {

    typealias ReservationID = String
    typealias ReasonText = String

    private let ticketRefundConfirmViewControllerFactory: (ReservationID, ReasonText, RefundAccountInformation) -> TicketRefundConfirmViewController

    private let viewModel: TicketRefundRequestViewModel
    private let disposeBag = DisposeBag()

    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "취소 요청하기"))

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .grey95
        scrollView.showsVerticalScrollIndicator = false

        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 12

        return stackView
    }()

    private let concertInformationView = ConcertInformationView()

    private lazy var accountHolderTitleLabel = self.makeTitleLabel(title: "예금주 정보")
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
    
    private lazy var accountHolderStackView: UIStackView = self.makeContentStackView([
        self.accountHolderTitleLabel,
        self.accountHolderNameView,
        self.accountHolderPhoneNumberView
    ])

    private lazy var refundAccountTitleLabel = self.makeTitleLabel(title: "환불 계좌 정보")
    private let selectRefundBankView = SelectRefundBankView()
    private let refundAccountNumberView = RefundAccountNumberView()

    private lazy var refundAccountInformationView: UIStackView = self.makeContentStackView([
        self.refundAccountTitleLabel,
        self.selectRefundBankView,
        self.refundAccountNumberView
    ])

    private lazy var refundInformationTitlelabel = self.makeTitleLabel(title: "환불 정보")
    private let refundAmountView = ReservationHorizontalStackView(title: "환불 예정 금액", alignment: .right)
    private let refundMethodView = ReservationHorizontalStackView(title: "환불 수단", alignment: .right)

    private lazy var refundInformationStackView = self.makeContentStackView([
        self.refundInformationTitlelabel,
        self.refundAmountView,
        self.refundMethodView
    ])

    private let requestRefundButton = BooltiButton(title: "취소 요청하기")

    private let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black100.withAlphaComponent(0.85)
        view.isHidden = true

        return view
    }()

    init(
        ticketRefundConfirmViewControllerFactory: @escaping (ReservationID, ReasonText, RefundAccountInformation) -> TicketRefundConfirmViewController,
        viewModel: TicketRefundRequestViewModel
    ) {
        self.ticketRefundConfirmViewControllerFactory = ticketRefundConfirmViewControllerFactory
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

        // API 붙히면 넣어줄 값
        self.refundAmountView.setData("5,000원")
        self.refundMethodView.setData("계좌이체")

        self.view.addSubviews([
            self.navigationBar,
            self.scrollView,
            self.dimmedBackgroundView
        ])

        self.scrollView.addSubview(self.contentStackView)

        self.configureConstraints()
        self.contentStackView.addArrangedSubviews([
            self.concertInformationView,
            self.accountHolderStackView,
            self.refundAccountInformationView,
            self.refundInformationStackView,
            self.requestRefundButton,
        ])
//
//        self.accountHolderStackView.snp.makeConstraints { make in
//            make.top.equalTo(self.concertInformationView.snp.bottom).offset(12)
//            make.horizontalEdges.equalToSuperview()
//        }
//
//        self.refundAccountInformationView.snp.makeConstraints { make in
//            make.height.equalTo(205)
//            make.top.equalTo(self.accountHolderStackView.snp.bottom).offset(12)
//            make.horizontalEdges.equalToSuperview()
//        }
//
//        self.refundAccountTitleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(20)
//            make.left.equalToSuperview().inset(20)
//        }
//
//        self.refundInformationStackView.snp.makeConstraints { make in
//            make.top.equalTo(self.refundAccountInformationView.snp.bottom).offset(20)
//            make.horizontalEdges.equalToSuperview()
//        }
//
//        self.selectRefundBankView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(20)
//            make.top.equalTo(self.refundAccountTitleLabel.snp.bottom).offset(20)
//        }
//
//        self.refundAccountNumberView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(20)
//            make.top.equalTo(self.selectRefundBankView.snp.bottom).offset(12)
//        }
//
//        self.requestRefundButton.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(20)
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
//        }
//
//        self.dimmedBackgroundView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }

    }

    private func configureConstraints() {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        let screenWidth = window.screen.bounds.width

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.bottom.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.concertInformationView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
        }

        self.accountHolderStackView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
        }

        self.refundAccountInformationView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
        }

        self.refundInformationStackView.snp.makeConstraints { make in
            make.width.equalTo(screenWidth)
        }

        self.requestRefundButton.snp.makeConstraints { make in
            make.width.equalTo(screenWidth-40)
        }
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
                let viewController = TicketRefundBankSelectionViewController(selectedBank: owner.viewModel.output.selectedBank.value)

                viewController.selectedItem = { item in
                    owner.dimmedBackgroundView.isHidden = true
                    guard let item else { return }
                    owner.viewModel.input.selectedItem.accept(item)
                }
                owner.dimmedBackgroundView.isHidden = false

                owner.present(viewController, animated: true)
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

        self.viewModel.output.isValidrefundAccountNumber
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, isValid in
                owner.refundAccountNumberView.isValidTextTyped = isValid
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.selectedBank
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, bankEntity in
                guard let bankEntity else { return }
                owner.selectRefundBankView.setData(with: bankEntity.bankName)
            }
            .disposed(by: self.disposeBag)

        Observable.combineLatest(
            self.viewModel.output.isAccoundHolderNameEmpty,
            self.viewModel.output.isAccoundHolderPhoneNumberEmpty,
            self.viewModel.output.isValidrefundAccountNumber,
            self.viewModel.output.selectedBank
        )
            .asDriver(onErrorDriveWith: .never())
            .drive { [weak self] (isAccountHolderEmpty, isAccountPhoneNumberEmpty, isValidNumber, selectedBank) in

                self?.requestRefundButton.isEnabled = !isAccountHolderEmpty && !isAccountPhoneNumberEmpty && isValidNumber && (selectedBank != nil)
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
                    owner.view.frame.origin.y -= (keyBoardHeight - height + 650)
                }
            }
            .disposed(by: self.disposeBag)

        self.accountHolderNameView.contentTextField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                guard let text = owner.accountHolderNameView.contentTextField.text else { return }
                owner.viewModel.input.accoundHolderNameText.accept(text)
            })
            .disposed(by: self.disposeBag)
        
        self.accountHolderPhoneNumberView.contentTextField.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                guard let text = owner.accountHolderPhoneNumberView.contentTextField.text else { return }
                
                owner.accountHolderPhoneNumberView.contentTextField.text = text.replacingOccurrences(of: "-", with: "")
            })
            .disposed(by: self.disposeBag)
        
        self.accountHolderPhoneNumberView.contentTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, changedText in
                let formattedNumber = changedText.formatPhoneNumber()
                owner.accountHolderPhoneNumberView.contentTextField.text = formattedNumber
                
                if formattedNumber.count > 13 {
                    owner.accountHolderPhoneNumberView.contentTextField.deleteBackward()
                }
            })
            .disposed(by: self.disposeBag)


        self.accountHolderPhoneNumberView.contentTextField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                guard let text = owner.accountHolderPhoneNumberView.contentTextField.text else { return }
                owner.viewModel.input.accountHolderPhoneNumberText.accept(text)
            })
            .disposed(by: self.disposeBag)

        self.refundAccountNumberView.accountNumberTextField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(with: self) { owner, _ in
                guard let text = owner.refundAccountNumberView.accountNumberTextField.text else { return }
                owner.viewModel.input.refundAccountNumberText.accept(text)
            }
            .disposed(by: self.disposeBag)

        self.requestRefundButton.rx.tap
            .bind(with: self) { owner, _ in
                let input = owner.viewModel.input
                let refundAccountInfomration = RefundAccountInformation(
                    accountHolderName: input.accoundHolderNameText.value,
                    accountHolderPhoneNumber: input.accountHolderPhoneNumberText.value,
                    accountBankName: owner.selectRefundBankView.bankNameLabel.text ?? "",
                    accountNumber: input.refundAccountNumberText.value
                )
                let viewController = owner.ticketRefundConfirmViewControllerFactory(
                    owner.viewModel.reservationID,
                    owner.viewModel.reasonText,
                    refundAccountInfomration
                )
                viewController.modalPresentationStyle = .overCurrentContext
                owner.definesPresentationContext = true
                owner.present(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func makeTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .subhead2
        label.textColor = .grey10

        return label
    }

    private func makeContentStackView(_ subViews: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .grey90
        stackView.isLayoutMarginsRelativeArrangement = true

        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        stackView.addArrangedSubviews(subViews)
        stackView.spacing = 16
        stackView.setCustomSpacing(20, after: subViews[0])

        return stackView
    }
}
