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
    
    typealias ReservationId = Int
    
    private let viewModel: TicketingDetailViewModel
    private let disposeBag = DisposeBag()
    private let ticketingConfirmViewControllerFactory: (TicketingEntity) -> TicketingConfirmViewController
    private let tossPayementsViewControllerFactory: (TicketingEntity) -> TossPaymentViewController
    private let ticketingCompletionViewControllerFactory: (ReservationId) -> TicketingCompletionViewController
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
    
    private let invitationCodeView = InvitationCodeView()
    
    private let policyView = PolicyView()
    
    private let agreeView = AgreeView()
    
    private let middlemanPolicyView = MiddlemanPolicyView()
    
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
                                  self.invitationCodeView,
                                  self.policyView,
                                  self.agreeView,
                                  self.middlemanPolicyView,
                                  self.businessInfoView])
        return view
    }()
    
    private let payButton = BooltiButton(title: "\(0.formattedCurrency())원 결제하기")
    
    // MARK: Init
    
    init(
        viewModel: TicketingDetailViewModel,
        ticketingConfirmViewControllerFactory: @escaping (TicketingEntity) -> TicketingConfirmViewController,
        tossPayementsViewControllerFactory: @escaping (TicketingEntity) -> TossPaymentViewController,
        ticketingCompletionViewControllerFactory: @escaping (ReservationId) -> TicketingCompletionViewController,
        businessInfoViewControllerFactory: @escaping () -> BusinessInfoViewController
    ) {
        self.viewModel = viewModel
        self.ticketingConfirmViewControllerFactory = ticketingConfirmViewControllerFactory
        self.tossPayementsViewControllerFactory = tossPayementsViewControllerFactory
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
        self.setData()
        self.bindInputs()
        self.bindOutputs()
        self.bindUIComponents()
        self.viewModel.fetchConcertDetail()
    }
}

// MARK: - Methods

extension TicketingDetailViewController {
    
    private func setData() {
        let selectedTicket = self.viewModel.selectedTicket
        self.ticketInfoView.setData(entity: selectedTicket)
        self.payButton.setTitle("\((selectedTicket.count * selectedTicket.price).formattedCurrency())원 결제하기", for: .normal)
        
        if selectedTicket.price == 0 {
            self.depositorInputView.isHidden = true
            self.policyView.isHidden = true
        }
        
        if selectedTicket.ticketType == .invitation {
            self.bindInvitationView()
        } else {
            self.invitationCodeView.isHidden = true
        }
    }
    
    private func bindUIComponents() {
        self.bindNavigationBar()
        self.bindUserInputView()
        self.bindAgreeView()
        self.bindBusinessInfoView()
    }
    
    private func bindInputs() {
        self.payButton.rx.tap
            .bind(to: self.viewModel.input.didPayButtonTap)
            .disposed(by: self.disposeBag)
        
        self.ticketHolderInputView.nameTextField.rx.text.orEmpty
            .bind(to: self.viewModel.input.ticketHolderName)
            .disposed(by: self.disposeBag)
        
        self.ticketHolderInputView.phoneNumberTextField.rx.text.orEmpty
            .map { $0.replacingOccurrences(of: "-", with: "") }
            .bind(to: self.viewModel.input.ticketHolderPhoneNumber)
            .disposed(by: self.disposeBag)
        
        self.depositorInputView.nameTextField.rx.text.orEmpty
            .bind(to: self.viewModel.input.depositorName)
            .disposed(by: self.disposeBag)
        
        self.depositorInputView.phoneNumberTextField.rx.text.orEmpty
            .map { $0.replacingOccurrences(of: "-", with: "") }
            .bind(to: self.viewModel.input.depositorPhoneNumber)
            .disposed(by: self.disposeBag)
        
        self.invitationCodeView.codeTextField.rx.text.orEmpty
            .bind(to: self.viewModel.input.invitationCode)
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.navigateToConfirm
            .bind(with: self) { owner, _ in
                guard let ticketingEntity = owner.viewModel.output.ticketingEntity else { return }
                
                let ticketingConfirmVC = owner.ticketingConfirmViewControllerFactory(ticketingEntity)
                ticketingConfirmVC.modalPresentationStyle = .overFullScreen
                
                ticketingConfirmVC.onDismiss = { ticketingEntity in
                    if ticketingEntity.selectedTicket.price == 0 {
                        let viewController = owner.ticketingCompletionViewControllerFactory(ticketingEntity.reservationId)
                        owner.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        let tossVC = owner.tossPayementsViewControllerFactory(ticketingEntity)
                        tossVC.modalPresentationStyle = .overFullScreen
    
                        tossVC.onDismissOrderSuccess = { ticketingEntity in
                            let viewController = owner.ticketingCompletionViewControllerFactory(ticketingEntity.reservationId)
                            owner.navigationController?.pushViewController(viewController, animated: true)
                        }
    
                        tossVC.onDismissOrderFailure = {
                            // TODO: - 실패 팝업창 띄우기
                        }
    
                        owner.present(tossVC, animated: true)
                    }
                }
                
                owner.present(ticketingConfirmVC, animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.concertDetail
            .bind(with: self) { owner, entity in
                guard let entity = entity else { return }
                owner.concertInfoView.setData(posterURL: entity.posters.first!.thumbnailPath,
                                              title: entity.name,
                                              datetime: entity.date)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.invitationCodeState
            .skip(1)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .incorrect)
            .drive(with: self) { owner, state in
                owner.invitationCodeView.setCodeState(state)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.isPaybuttonEnable
            .bind(to: self.payButton.rx.isEnabled)
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
                .map { $0.formatPhoneNumber() }
                .distinctUntilChanged()
                .asDriver(onErrorJustReturn: "")
                .drive(with: self, onNext: { owner, formattedNumber in
                    inputView.phoneNumberTextField.text = formattedNumber
                    
                    if formattedNumber.count > 13 {
                        inputView.phoneNumberTextField.deleteBackward()
                    }
                })
                .disposed(by: self.disposeBag)
        }
        
        self.depositorInputView.isEqualButtonSelected
            .bind(to: self.viewModel.input.isEqualButtonSelected)
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
                owner.viewModel.input.invitationCode.accept(owner.invitationCodeView.codeTextField.text ?? "")
            })
            .disposed(by: self.disposeBag)
        
        self.invitationCodeView.didUseButtonTap()
            .emit(to: self.viewModel.input.didInvitationCodeUseButtonTap)
            .disposed(by: self.disposeBag)
    }
    
    private func bindAgreeView() {
        self.agreeView.didCollectionOpenButtonTap()
            .emit(with: self) { owner, _ in
                guard let url = URL(string: AppInfo.informationCollectionPolicyLink) else { return }
                owner.openSafari(with: url)
            }
            .disposed(by: self.disposeBag)
        
        self.agreeView.didOfferOpenButtonTap()
            .emit(with: self) { owner, _ in
                guard let url = URL(string: AppInfo.informationOfferPolicyLink) else { return }
                owner.openSafari(with: url)
            }
            .disposed(by: self.disposeBag)
        
        self.agreeView.isAllAgreeButtonSelected
            .bind(to: self.viewModel.input.isAllAgreeButtonSelected)
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
