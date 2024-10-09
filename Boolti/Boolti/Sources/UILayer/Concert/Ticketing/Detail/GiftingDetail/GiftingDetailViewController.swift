//
//  GiftingDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 6/23/24.
//

import UIKit

import RxSwift

final class GiftingDetailViewController: BooltiViewController {
    
    // MARK: Properties
    
    typealias GiftID = Int
    
    private let viewModel: GiftingDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let giftingConfirmViewControllerFactory: (GiftingEntity) -> GiftingConfirmViewController
    private let tossPaymentsViewControllerFactory: (GiftingEntity) -> TossPaymentViewController
    private let giftCompletionViewControllerFactory: (GiftID) -> GiftCompletionViewController
    private let businessInfoViewControllerFactory: () -> BusinessInfoViewController
    
    private var isScrollViewOffsetChanged: Bool = false
    private var changedScrollViewOffsetY: CGFloat = 0
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "선물하기"))
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 0, bottom: 24, right: 0)
        view.keyboardDismissMode = .onDrag
        view.delegate = self
        return view
    }()
    
    private let selectCardView = SelectCardView()
    
    private let senderInputView = UserInfoInputView(title: "보내는 분 정보", showEqualButton: false, showInfoLabel: false)
    
    private let receiverInputView = UserInfoInputView(title: "받는 분 정보", showEqualButton: false, showInfoLabel: true)
    
    private let concertTicketInfoView = ConcertTicketInfoView()
    
    private let policyView = PolicyView()
    
    private let agreeView = AgreeView()
    
    private let middlemanPolicyView = MiddlemanPolicyView()
    
    private let businessInfoView = BooltiBusinessInfoView()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12
        
        view.addArrangedSubviews([self.selectCardView,
                                  self.receiverInputView,
                                  self.senderInputView,
                                  self.concertTicketInfoView,
                                  self.policyView,
                                  self.agreeView,
                                  self.middlemanPolicyView,
                                  self.businessInfoView])
        return view
    }()
    
    private lazy var buttonBackgroundView: UIView = {
        let view = UIView()
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 24)
        gradient.colors = [UIColor.grey95.withAlphaComponent(0.0).cgColor, UIColor.grey95.cgColor]
        gradient.locations = [0.1, 0.7]
        view.layer.insertSublayer(gradient, at: 0)
        
        return view
    }()
    
    private let payButton = BooltiButton(title: "결제하기")
    
    private let popupView = BooltiPopupView()
    
    // MARK: Initailizer
    
    init(viewModel: GiftingDetailViewModel,
         giftingConfirmViewControllerFactory: @escaping (GiftingEntity) -> GiftingConfirmViewController,
         tossPaymentsViewControllerFactory: @escaping (GiftingEntity) -> TossPaymentViewController,
         giftCompletionViewControllerFactory: @escaping (GiftID) -> GiftCompletionViewController,
         businessInfoViewControllerFactory: @escaping () -> BusinessInfoViewController) {
        self.viewModel = viewModel
        self.giftingConfirmViewControllerFactory = giftingConfirmViewControllerFactory
        self.tossPaymentsViewControllerFactory = tossPaymentsViewControllerFactory
        self.giftCompletionViewControllerFactory = giftCompletionViewControllerFactory
        self.businessInfoViewControllerFactory = businessInfoViewControllerFactory
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureKeyboardNotification()
        self.configureGesture()
        self.bindUIComponents()
        self.bindInputs()
        self.bindOutputs()
    }
    
}

// MARK: - Methods

extension GiftingDetailViewController {
    
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
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
                if owner.isScrollViewOffsetChanged {
                    owner.scrollView.setContentOffset(CGPoint(x: 0, y: owner.scrollView.contentOffset.y - owner.changedScrollViewOffsetY), animated: true)
                    owner.isScrollViewOffsetChanged = false
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindUIComponents() {
        self.bindNavigationBar()
        self.bindSelectCardView()
        self.bindUserInputView()
        self.bindConcertTicketInfoView()
        self.bindBusinessInfoView()
        self.bindAgreeView()
        self.bindPopupView()
    }
    
    private func bindNavigationBar() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindSelectCardView() {
        self.selectCardView.messageTextView.rx.text.orEmpty
            .bind(to: self.viewModel.input.message)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.cardImages
            .bind(to: self.selectCardView.cardImageCollectionView.rx
                .items(cellIdentifier: CardImageCollectionViewCell.className,
                       cellType: CardImageCollectionViewCell.self)
            ) { index, entity, cell in
                cell.setData(with: entity.thumbnailPath)
            }
            .disposed(by: self.disposeBag)
        
        self.selectCardView.cardImageCollectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: self.viewModel.input.selectedImageIndex)
            .disposed(by: self.disposeBag)
        
        self.selectCardView.cardImageCollectionView.rx.willDisplayCell
            .take(1)
            .bind(with: self) { owner, item in
                item.cell.isSelected = true
                owner.selectCardView.cardImageCollectionView.selectItem(at: item.at, animated: false, scrollPosition: .left)
                owner.viewModel.input.selectedImageIndex.accept(item.at.item)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindUserInputView() {
        [self.receiverInputView, self.senderInputView].forEach { inputView in
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
    }
    
    private func bindConcertTicketInfoView() {
        self.viewModel.output.concertDetail
            .subscribe(with: self) { owner, entity in
                guard let concertInfo = entity else { return }
                let ticketInfo = owner.viewModel.selectedTicket
                
                owner.concertTicketInfoView.setData(posterURL: concertInfo.posters.first!.thumbnailPath,
                                                    title: concertInfo.name,
                                                    datetime: concertInfo.date,
                                                    ticketInfo: ticketInfo)
                owner.payButton.setTitle("\((ticketInfo.count * ticketInfo.price).formattedCurrency())원 결제하기", for: .normal)
            }
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
    
    private func bindAgreeView() {
        self.agreeView.didCollectionOpenButtonTap()
            .emit(with: self) { owner, _ in
                owner.presentAgreementViewController(
                    urlString: "https://boolti.in/site-policy/privacy",
                    detentHeight: 628
                )
            }
            .disposed(by: self.disposeBag)
        
        self.agreeView.didOfferOpenButtonTap()
            .emit(with: self) { owner, _ in
                owner.presentAgreementViewController(
                    urlString: "https://boolti.in/site-policy/consent",
                    detentHeight: 512
                )
            }
            .disposed(by: self.disposeBag)
        
        self.agreeView.isAllAgreeButtonSelected
            .bind(to: self.viewModel.input.isAllAgreeButtonSelected)
            .disposed(by: self.disposeBag)
    }

    private func presentAgreementViewController(urlString: String, detentHeight: CGFloat) {
        guard let url = URL(string: urlString) else { return }
        let agreementViewController = AgreementViewController(url: url)
        let customDent = UISheetPresentationController.Detent.custom { _ in
            return detentHeight
        }
        if let sheet = agreementViewController.sheetPresentationController {
            sheet.detents = [customDent]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
        }

        self.present(agreementViewController, animated: true)
    }

    private func bindPopupView() {
        self.popupView.didConfirmButtonTap()
            .emit(with: self) { owner, _ in
                switch owner.popupView.popupType {
                case .soldoutBeforePayment:
                    owner.navigationController?.popViewController(animated: true)
                case .ticketingFailed:
                    owner.popupView.isHidden = true
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindInputs() {
        self.payButton.rx.tap
            .bind(to: self.viewModel.input.didPayButtonTap)
            .disposed(by: self.disposeBag)
        
        self.receiverInputView.nameTextField.rx.text.orEmpty
            .bind(to: self.viewModel.input.receiverName)
            .disposed(by: self.disposeBag)
        
        self.receiverInputView.phoneNumberTextField.rx.text.orEmpty
            .map { $0.replacingOccurrences(of: "-", with: "") }
            .bind(to: self.viewModel.input.receiverPhoneNumber)
            .disposed(by: self.disposeBag)
        
        self.senderInputView.nameTextField.rx.text.orEmpty
            .bind(to: self.viewModel.input.senderName)
            .disposed(by: self.disposeBag)
        
        self.senderInputView.phoneNumberTextField.rx.text.orEmpty
            .map { $0.replacingOccurrences(of: "-", with: "") }
            .bind(to: self.viewModel.input.senderPhoneNumber)
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.isPaybuttonEnable
            .bind(to: self.payButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.selectedCardImageEntity
            .bind(with: self) { owner, image in
                guard let image = image else { return }
                owner.selectCardView.setSelectedImage(with: image.path)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.navigateToConfirm
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                guard let giftingEntity = owner.viewModel.output.giftingEntity else { return }

                let giftingConfirmVC = owner.giftingConfirmViewControllerFactory(giftingEntity)
                giftingConfirmVC.modalPresentationStyle = .overFullScreen

                giftingConfirmVC.onDismiss = { giftingEntity in
                    if giftingEntity.selectedTicket.price == 0 {
                        
                        // TODO: - 옵셔널 수정 필요 entity랑 분리하기
                        let viewController = owner.giftCompletionViewControllerFactory(giftingEntity.giftId ?? -1)
                        owner.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        let tossVC = owner.tossPaymentsViewControllerFactory(giftingEntity)
                        tossVC.modalPresentationStyle = .overFullScreen

                        tossVC.onDismissOrderSuccess = { giftId in
                            let viewController = owner.giftCompletionViewControllerFactory(giftId)
                            owner.navigationController?.pushViewController(viewController, animated: true)
                        }

                        tossVC.onDismissOrderFailure = { error in
                            switch error {
                            case .noQuantity:
                                owner.popupView.showPopup(with: .soldoutBeforePayment)
                            case .tossError:
                                owner.popupView.showPopup(with: .ticketingFailed)
                            }
                        }

                        owner.present(tossVC, animated: true)
                    }
                }
                
                giftingConfirmVC.onDismissOrderFailure = {
                    owner.popupView.showPopup(with: .soldoutBeforePayment)
                }
                
                owner.present(giftingConfirmVC, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UIScrollViewDelegate

extension GiftingDetailViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrollViewOffsetChanged = false
    }
    
}

// MARK: - UI

extension GiftingDetailViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.payButton.isEnabled = false
        
        self.scrollView.addSubviews([self.stackView])
        self.view.addSubviews([self.navigationBar,
                               self.scrollView,
                               self.buttonBackgroundView,
                               self.payButton,
                               self.popupView])
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
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
        
        self.popupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
