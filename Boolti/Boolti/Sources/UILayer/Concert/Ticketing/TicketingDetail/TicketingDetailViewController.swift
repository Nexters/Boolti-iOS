//
//  TicketingDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit

import RxSwift
import RxCocoa

final class TicketingDetailViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: TicketingDetailViewModel
    private let disposeBag = DisposeBag()
    private let ticketingConfirmViewControllerFactory: (TicketingEntity) -> TicketingConfirmViewController
    private let ticketingCompletionViewControllerFactory: (TicketingEntity) -> TicketingCompletionViewController
    private let businessInfoViewControllerFactory: () -> BusinessInfoViewController
    
    private var isScrollViewOffsetChanged: Bool = false
    private var changedScrollViewOffsetY: CGFloat = 0
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "결제하기"))
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 0, bottom: 24, right: 0)
        view.keyboardDismissMode = .onDrag
        view.delegate = self
        return view
    }()
    
    private let concertInfoView = ConcertInfoView()
    
    private let ticketHolderInputView = UserInfoInputView(type: .ticketHolder)
    
    private let depositorInputView = UserInfoInputView(type: .depositor)
    
    private let ticketInfoView = TicketInfoView()
    
    private let paymentMethodView = PaymentMethodView()
    
    private let invitationCodeView = InvitationCodeView()
    
    private let policyView = PolicyView()
    
    private let businessInfoView = BooltiBusinessInfoView()

    private lazy var buttonBackgroundView: UIView = {
        let view = UIView()

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 24)
        gradient.colors = [UIColor.grey95.withAlphaComponent(0.0).cgColor, UIColor.grey95.cgColor]
        gradient.locations = [0.1, 0.7]
        view.layer.insertSublayer(gradient, at: 0)

        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        
        view.addArrangedSubviews([self.concertInfoView,
                                  self.ticketHolderInputView,
                                  self.depositorInputView,
                                  self.ticketInfoView,
                                  self.paymentMethodView,
                                  self.invitationCodeView,
                                  self.policyView,
                                  self.businessInfoView])
        return view
    }()
    
    private let payButton = BooltiButton(title: "\(0.formattedCurrency())원 결제하기")
    
    // MARK: Init

    init(
        viewModel: TicketingDetailViewModel,
        ticketingConfirmViewControllerFactory: @escaping (TicketingEntity) -> TicketingConfirmViewController,
        ticketingCompletionViewControllerFactory: @escaping (TicketingEntity) -> TicketingCompletionViewController,
        businessInfoViewControllerFactory: @escaping () -> BusinessInfoViewController
    ) {
        self.viewModel = viewModel
        self.ticketingConfirmViewControllerFactory = ticketingConfirmViewControllerFactory
        self.ticketingCompletionViewControllerFactory = ticketingCompletionViewControllerFactory
        self.businessInfoViewControllerFactory = businessInfoViewControllerFactory
        super.init()
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureToastView(isButtonExisted: true)
        self.configureUI()
        self.configureConstraints()
        self.configureGesture()
        self.configureKeyboardNotification()
        self.bindInputs()
        self.bindOutputs()
        self.bindUIComponents()
        self.viewModel.fetchConcertDetail()
    }
}

// MARK: - Methods

extension TicketingDetailViewController {
    
    private func bindUIComponents() {
        self.bindNavigationBar()
        self.bindUserInputView()
        self.bindPolicyView()
        self.bindBusinessInfoView()
    }
    
    private func bindInputs() {
        self.payButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.setTicketingData()
            })
            .disposed(by: self.disposeBag)
        
        self.paymentMethodView.didDepositButtonTap()
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.showToast(message: "지금은 계좌 이체로만 결제할 수 있어요")
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.navigateToConfirm
            .bind(with: self) { owner, _ in
                guard let ticketingEntity = self.viewModel.output.ticketingEntity else { return }
                
                let viewController = owner.ticketingConfirmViewControllerFactory(ticketingEntity)
                viewController.modalPresentationStyle = .overFullScreen
                
                viewController.onDismiss = { ticketingEntity in
                    let viewController = owner.ticketingCompletionViewControllerFactory(ticketingEntity)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                }
                
                owner.present(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.concertDetail
            .bind(with: self) { owner, concertDetailEntity in
                owner.concertInfoView.setData(posterURL: concertDetailEntity.posters.first!.thumbnailPath,
                                              title: concertDetailEntity.name,
                                              datetime: concertDetailEntity.date)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.selectedTicket
            .take(1)
            .bind(with: self, onNext: { owner, entity in
                owner.ticketInfoView.setData(entity: entity)
                owner.payButton.setTitle("\(entity.price.formattedCurrency())원 결제하기", for: .normal)
                
                if entity.ticketType == .invite {
                    owner.depositorInputView.isHidden = true
                    owner.paymentMethodView.isHidden = true
                    owner.policyView.isHidden = true
                    owner.bindInvitationView()
                } else {
                    owner.invitationCodeView.isHidden = true
                    owner.bindSalesView()
                }
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.invitationCodeState
            .skip(1)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .incorrect)
            .drive(with: self) { owner, state in
                owner.invitationCodeView.setCodeState(state)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindNavigationBar() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindUserInputView() {
        [self.ticketHolderInputView, self.depositorInputView].forEach { inputView in
            inputView.phoneNumberTextField.rx.text
                .orEmpty
                .distinctUntilChanged()
                .asDriver(onErrorJustReturn: "")
                .drive(with: self, onNext: { owner, changedText in
                    let formattedNumber = changedText.formatPhoneNumber()
                    inputView.phoneNumberTextField.text = formattedNumber
                    
                    if formattedNumber.count > 13 {
                        inputView.phoneNumberTextField.deleteBackward()
                    }
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    private func checkInputViewTextFieldFilled(inputType: UserInfoInputType)  -> Observable<Bool> {
        var inputView: UserInfoInputView
        switch inputType {
        case .ticketHolder:
            inputView = ticketHolderInputView
        case .depositor:
            inputView = depositorInputView
        }
        let nameTextObservable = inputView.nameTextField.rx.text.orEmpty
        let phoneNumberTextObservable = inputView.phoneNumberTextField.rx.text.orEmpty
        
        return Observable.combineLatest(nameTextObservable, phoneNumberTextObservable, inputView.isEqualButtonSelected)
            .map { nameText, phoneNumberText, isEqualButtonSelected in
                return (!nameText.trimmingCharacters(in: .whitespaces).isEmpty && !phoneNumberText.trimmingCharacters(in: .whitespaces).isEmpty) || (!inputView.isEqualButton.isHidden && isEqualButtonSelected)
            }
    }
    
    private func bindSalesView() {
        Observable.combineLatest(self.checkInputViewTextFieldFilled(inputType: .ticketHolder),
                                 self.checkInputViewTextFieldFilled(inputType: .depositor))
            .map { $0 && $1 }
            .distinctUntilChanged()
            .bind(to: self.payButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
    
    private func bindInvitationView() {
        self.invitationCodeView.codeTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, changedText in
                if changedText.count > 8 {
                    owner.invitationCodeView.codeTextField.deleteBackward()
                }
            })
            .disposed(by: self.disposeBag)
        
        self.invitationCodeView.didUseButtonTap()
            .emit(with: self) { owner, _ in
                guard let code = owner.invitationCodeView.codeTextField.text?.trimmingCharacters(in: .whitespaces)
                else { return }
                
                if code.isEmpty {
                    owner.viewModel.output.invitationCodeState.accept(.empty)
                } else {
                    owner.viewModel.checkInvitationCode(invitationCode: code)
                }
            }
            .disposed(by: self.disposeBag)
        
        Observable.combineLatest(self.checkInputViewTextFieldFilled(inputType: .ticketHolder),
                                 self.viewModel.output.invitationCodeState)
        .map { ( isTicketHolderFilled, codeState ) in
            return isTicketHolderFilled && codeState == .verified
        }
        .distinctUntilChanged()
        .bind(to: self.payButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
    }
    
    private func bindPolicyView() {
        self.policyView.policyLabelHeight
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self, onNext: { owner, viewHeight in
                
                let bottomOffset = CGPoint(x: 0, y: owner.scrollView.contentSize.height - owner.scrollView.bounds.height + viewHeight - 66 + 24)
                owner.scrollView.setContentOffset(bottomOffset, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindBusinessInfoView() {
        self.businessInfoView.didInfoButtonTap()
            .emit(with: self) { owner, _ in
                let viewController = self.businessInfoViewControllerFactory()
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
                  let currentTextField = UIResponder.currentResponder as? UITextField else { return }
            
            let keyboardTopY = keyboardFrame.cgRectValue.origin.y
            let convertedTextFieldFrame = self.view.convert(currentTextField.frame,
                                                            from: currentTextField.superview)
            let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height
            if textFieldBottomY > keyboardTopY * 0.9 {
                let changeOffset = textFieldBottomY - keyboardTopY + convertedTextFieldFrame.size.height
                self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y + changeOffset), animated: true)
                
                self.isScrollViewOffsetChanged = true
                self.changedScrollViewOffsetY = changeOffset
            }
        }
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
                if self.isScrollViewOffsetChanged {
                    owner.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentOffset.y - self.changedScrollViewOffsetY), animated: true)
                    self.isScrollViewOffsetChanged = false
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setTicketingData() {
        guard let ticketHolderName = self.ticketHolderInputView.nameTextField.text,
              let ticketHolderPhoneNumber = self.ticketHolderInputView.phoneNumberTextField.text?.replacingOccurrences(of: "-", with: "")
        else { return }
        
        switch self.viewModel.selectedTicket.value.ticketType {
        case .sales:
            guard let depositorName = self.depositorInputView.nameTextField.text,
                  let depositorPhoneNumber = self.depositorInputView.phoneNumberTextField.text?.replacingOccurrences(of: "-", with: "") else { return }
            
            self.viewModel.setSalesTicketingData(ticketHolderName: ticketHolderName,
                                                 ticketHolderPhoneNumber: ticketHolderPhoneNumber,
                                                 depositorName: depositorName.isEmpty ? ticketHolderName : depositorName,
                                                 depositorPhoneNumber: depositorPhoneNumber.isEmpty ? ticketHolderPhoneNumber : depositorPhoneNumber)
        case .invite:
            guard let invitationCode = self.invitationCodeView.codeTextField.text else { return }
            
            self.viewModel.setInvitationTicketingData(ticketHolderName: ticketHolderName,
                                                      ticketHolderPhoneNumber: ticketHolderPhoneNumber,
                                                      invitationCode: invitationCode)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension TicketingDetailViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrollViewOffsetChanged = false
    }
}

// MARK: - UI

extension TicketingDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.scrollView, self.navigationBar, self.buttonBackgroundView, self.payButton])
        self.scrollView.addSubviews([self.stackView])
        
        self.view.backgroundColor = .grey95
        self.payButton.isEnabled = false
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(self.payButton.snp.top).offset(-8)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        }
        
        self.buttonBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(self.scrollView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(24)
        }

        self.payButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
        }
    }
}
