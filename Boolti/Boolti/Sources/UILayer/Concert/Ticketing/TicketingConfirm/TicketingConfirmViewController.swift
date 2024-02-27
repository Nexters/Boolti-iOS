//
//  TicketingConfirmViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/26/24.
//

import UIKit

import RxSwift
import RxCocoa

final class TicketingConfirmViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: TicketingConfirmViewModel
    private let disposeBag = DisposeBag()
    var onDismiss: ((TicketingEntity) -> ())?
    
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
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        return stackView
    }()
    
    private lazy var ticketHolderTitle = self.makeLabel(with: "예매자")
    private lazy var ticketHolderInfo = self.makeLabel(with: nil)
    private lazy var ticketHolderStackView = self.makeHorizontalStackView(with: [self.ticketHolderTitle, self.ticketHolderInfo])
    
    private lazy var depositorTitle = self.makeLabel(with: "입금자")
    private lazy var depositorInfo = self.makeLabel(with: nil)
    private lazy var depositorStackView = self.makeHorizontalStackView(with: [self.depositorTitle, self.depositorInfo])
    
    private lazy var ticketTitle = self.makeLabel(with: "티켓")
    private lazy var ticketInfo = self.makeLabel(with: nil)
    private lazy var ticketStackView = self.makeHorizontalStackView(with: [self.ticketTitle, self.ticketInfo])
    
    private lazy var methodTitle = self.makeLabel(with: "결제 수단")
    private lazy var methodInfo = self.makeLabel(with: nil)
    private lazy var methodStackView = self.makeHorizontalStackView(with: [self.methodTitle, self.methodInfo])
    
    private let payButton = BooltiButton(title: "결제하기")
    
    // MARK: Init
    
    init(viewModel: TicketingConfirmViewModel) {
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

extension TicketingConfirmViewController {
    
    private func makeLabel(with text: String?) -> BooltiUILabel {
        let label = BooltiUILabel()
        label.font = .body1
        label.text = text
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = text != nil ? .grey30 : .grey15
        return label
    }
    
    private func makeHorizontalStackView(with labels: [BooltiUILabel]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 12
        stackView.addArrangedSubviews(labels)
        
        labels.first?.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        return stackView
    }
    
    private func setData() {
        let entity = self.viewModel.ticketingEntity
        
        self.ticketHolderInfo.text = "\(entity.ticketHolder.name)\n\(entity.ticketHolder.phoneNumber.formatPhoneNumber())"
        
        guard let selectedTicket = entity.selectedTicket.first else { return }
        self.ticketInfo.text = "\(selectedTicket.ticketName)\n\(entity.selectedTicket.count)매 / \(selectedTicket.price.formattedCurrency())원"
        
        switch selectedTicket.ticketType {
        case .sales:
            guard let depositor = entity.depositor else { return }
            self.depositorInfo.text = "\(depositor.name)\n\(depositor.phoneNumber.formatPhoneNumber())"
            self.methodInfo.text = "계좌 이체"
        case .invite:
            self.depositorStackView.isHidden = true
            self.methodInfo.text = "초청 티켓"
        }
    }

    private func bindViewModel() {
        self.viewModel.output.navigateToCompletion
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true) {
                    self.onDismiss?(owner.viewModel.ticketingEntity)
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

extension TicketingConfirmViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .black100.withAlphaComponent(0.85)
        
        self.view.addSubview(self.contentBackGroundView)
        
        self.contentBackGroundView.addSubviews([self.closeButton,
                                                self.titleLabel,
                                                self.infoStackView,
                                                self.payButton])
        
        self.infoStackView.addArrangedSubviews([self.ticketHolderStackView,
                                                self.depositorStackView,
                                                self.ticketStackView,
                                                self.methodStackView])
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
        
        self.payButton.snp.makeConstraints { make in
            make.top.equalTo(self.infoStackView.snp.bottom).offset(28)
            make.horizontalEdges.equalTo(self.infoStackView)
            make.bottom.equalTo(self.contentBackGroundView).offset(-20)
        }
    }
}
