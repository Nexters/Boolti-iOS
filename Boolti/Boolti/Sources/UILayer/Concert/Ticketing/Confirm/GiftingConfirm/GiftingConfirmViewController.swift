//
//  GiftingConfirmViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/21/24.
//

import UIKit

import RxSwift
import RxCocoa

final class GiftingConfirmViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: GiftingConfirmViewModel
    private let disposeBag = DisposeBag()
    var onDismiss: ((GiftingEntity) -> ())?
    var onDismissOrderFailure: (() -> ())?
    
    // MARK: UI Component
    
    private let contentBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)
        button.tintColor = .grey50
        return button
    }()
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey15
        label.text = "결제 정보를 확인해 주세요"
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .grey80
        stackView.layer.cornerRadius = 4
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16,
                                                                     leading: 20,
                                                                     bottom: 16,
                                                                     trailing: 20)
        return stackView
    }()
    
    private lazy var receiverTitle = self.makeLabel(with: "받는 분")
    private lazy var receiverInfo = self.makeLabel()
    private lazy var receiverStackView = self.makeHorizontalStackView(with: [self.receiverTitle, self.receiverInfo])
    
    private lazy var senderTitle = self.makeLabel(with: "보내는 분")
    private lazy var senderInfo = self.makeLabel()
    private lazy var senderStackView = self.makeHorizontalStackView(with: [self.senderTitle, self.senderInfo])
    
    private lazy var ticketTitle = self.makeLabel(with: "티켓")
    private lazy var ticketInfo = self.makeLabel()
    private lazy var ticketStackView = self.makeHorizontalStackView(with: [self.ticketTitle, self.ticketInfo])
    
    private let payButton = BooltiButton(title: "결제하기")
    
    // MARK: Init
    
    init(viewModel: GiftingConfirmViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.setData()
        self.bindViewModel()
        self.bindUIComponents()
    }
}

// MARK: - Methods

extension GiftingConfirmViewController {
    
    private func makeLabel(with text: String? = nil) -> BooltiUILabel {
        let label = BooltiUILabel()
        label.font = .body1
        label.numberOfLines = 2
        label.textColor = text != nil ? .grey30 : .grey15
        label.text = text
        return label
    }
    
    private func makeHorizontalStackView(with labels: [BooltiUILabel]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.addArrangedSubviews(labels)
        return stackView
    }
    
    private func setData() {
        let entity = self.viewModel.giftingEntity
        
        self.receiverInfo.text = "\(entity.receiver.name)\n\(entity.receiver.phoneNumber.formatPhoneNumber())"
        self.receiverInfo.setAlignment(.right)
        
        self.senderInfo.text = "\(entity.sender.name)\n\(entity.sender.phoneNumber.formatPhoneNumber())"
        self.senderInfo.setAlignment(.right)
        
        self.ticketInfo.text = "\(entity.selectedTicket.ticketName)\n\(entity.selectedTicket.count)매 / \((entity.selectedTicket.count * entity.selectedTicket.price).formattedCurrency())원"
        self.ticketInfo.setAlignment(.right)
    }

    private func bindViewModel() {
        self.viewModel.output.navigateToTossPayments
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true) {
                    self.onDismiss?(owner.viewModel.giftingEntity)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.navigateToCompletion
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true) {
                    self.onDismiss?(owner.viewModel.giftingEntity)
                }
            }
            .disposed(by: self.disposeBag)
            
        self.viewModel.output.didFreeOrderPaymentFailed
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true) {
                    self.onDismissOrderFailure?()
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindUIComponents() {
        self.closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.payButton.rx.tap
            .bind(to: self.viewModel.input.didPayButtonTap)
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension GiftingConfirmViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .black100.withAlphaComponent(0.85)
        
        self.view.addSubview(self.contentBackGroundView)
        
        self.contentBackGroundView.addSubviews([self.closeButton,
                                                self.titleLabel,
                                                self.infoStackView,
                                                self.payButton])
        
        self.infoStackView.addArrangedSubviews([self.receiverStackView,
                                                self.senderStackView,
                                                self.ticketStackView])
    }
    
    private func configureConstraints() {
        self.contentBackGroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.contentBackGroundView).offset(12)
            make.right.equalTo(self.contentBackGroundView).offset(-20)
            make.size.equalTo(24)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.closeButton.snp.bottom).offset(12)
            make.centerX.equalTo(self.contentBackGroundView)
        }
        
        self.infoStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(self.contentBackGroundView).inset(20)
        }
        
        self.ticketTitle.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        
        self.payButton.snp.makeConstraints { make in
            make.top.equalTo(self.infoStackView.snp.bottom).offset(28)
            make.horizontalEdges.equalTo(self.infoStackView)
            make.bottom.equalTo(self.contentBackGroundView).offset(-20)
        }
    }
}
