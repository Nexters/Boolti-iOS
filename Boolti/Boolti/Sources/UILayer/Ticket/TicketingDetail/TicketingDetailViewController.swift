//
//  TicketingDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TicketingDetailViewController: UIViewController {
    
    // MARK: Properties
    
    let viewModel: TicketingDetailViewModel
    private let disposeBag = DisposeBag()
    private let ticketingCompletionViewControllerFactory: (TicketingEntity) -> TicketingCompletionViewController
    
    private var isScrollViewOffsetChanged: Bool = false
    private var changedScrollViewOffsetY: CGFloat = 0
    
    // MARK: UI Component
    
    private let navigationView = BooltiNavigationView(type: .ticketingDetail)
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 0, bottom: 40, right: 0)
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
                                  self.policyView])
        return view
    }()
    
    private let payButton = BooltiButton(title: "\(0.formattedCurrency())원 결제하기")
    
    // MARK: Init

    init(
        viewModel: TicketingDetailViewModel,
        ticketingCompletionViewControllerFactory: @escaping (TicketingEntity) -> TicketingCompletionViewController
    ) {
        self.viewModel = viewModel
        self.ticketingCompletionViewControllerFactory = ticketingCompletionViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.configureGesture()
        self.configureKeyboardNotification()
        self.bindInputs()
        self.bindOutputs()
        
        // 확인용 - 공연 리스트 뷰 만들어지면 연결
        concertInfoView.setData(posterURL: "", title: "2024 TOGETHER LUCKY CLUB", datetime: Date())
    }
}

// MARK: - Methods

extension TicketingDetailViewController {
    
    private func checkGeneralTextFieldFilled() {
        Observable.combineLatest(self.ticketHolderInputView.isBothTextFieldsFilled(),
                                 self.depositorInputView.isBothTextFieldsFilled())
            .map { $0 && $1 }
            .distinctUntilChanged()
            .bind(to: self.payButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
    }
    
    private func checkInvitationTextFieldFilled() {
        Observable.combineLatest(self.ticketHolderInputView.isBothTextFieldsFilled(),
                                 self.viewModel.output.invitationCodeState)
        .map { ( isTicketHolderFilled, codeState ) in
            return isTicketHolderFilled && codeState == .verified
        }
        .distinctUntilChanged()
        .bind(to: self.payButton.rx.isEnabled)
        .disposed(by: self.disposeBag)
    }
    
    private func bindInputs() {
        self.viewModel.output.selectedTicket
            .take(1)
            .bind(with: self, onNext: { owner, entity in
                owner.ticketInfoView.setData(entity: entity)
                owner.payButton.setTitle("\(entity.price.formattedCurrency())원 결제하기", for: .normal)
                
                if entity.price == 0 {
                    owner.depositorInputView.isHidden = true
                    owner.checkInvitationTextFieldFilled()
                } else {
                    owner.invitationCodeView.isHidden = true
                    owner.checkGeneralTextFieldFilled()
                }
            })
            .disposed(by: self.disposeBag)
        
        self.navigationView.didBackButtonTap()
            .emit(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.payButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                
                // 테스트용 데이터
                let viewController = self.ticketingCompletionViewControllerFactory(TicketingEntity(ticketHolder: TicketingEntity.userInfo(name: .init(), phoneNumber: .init()), depositor: nil, selectedTicket: [self.viewModel.output.selectedTicket.value], paymentMethod: "", invitationCode: "asdf"))
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.invitationCodeView.didUseButtonTap()
            .emit(with: self) { owner, _ in
                if let codeInput = owner.invitationCodeView.codeTextField.text, codeInput.trimmingCharacters(in: .whitespaces).isEmpty {
                    owner.viewModel.output.invitationCodeState.accept(.empty)
                } else {
                    owner.viewModel.input.didUseButtonTap.onNext(())
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.invitationCodeState
            .skip(1)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .incorrect)
            .drive(with: self) { owner, state in
                owner.invitationCodeView.setCodeState(state)
            }
            .disposed(by: self.disposeBag)
        
        self.policyView.policyLabelHeight
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self, onNext: { owner, viewHeight in
                let bottomOffset = CGPoint(x: 0, y: owner.scrollView.contentSize.height - owner.scrollView.bounds.height + viewHeight)
                owner.scrollView.setContentOffset(bottomOffset, animated: true)
            })
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
        self.view.addSubviews([self.scrollView, self.navigationView, self.payButton])
        self.scrollView.addSubviews([self.stackView])
        
        self.view.backgroundColor = .grey95
        self.payButton.isEnabled = false
    }
    
    private func configureConstraints() {
        self.navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(self.payButton.snp.top).offset(-8)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        }
        
        self.payButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
        }
    }
}
