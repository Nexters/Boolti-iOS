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
    private let ticketingCompletionViewControllerFactory: (TicketingEntity) -> TicketingCompletionViewController
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead2
        label.textColor = .grey15
        label.text = "결제 정보를 확인해 주세요"
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .grey80
        stackView.layer.cornerRadius = 4
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        return stackView
    }()
    
    private let payButton = BooltiButton(title: "결제하기")
    
    // MARK: Init
    
    init(viewModel: TicketingConfirmViewModel,
         ticketingCompletionViewControllerFactory: @escaping (TicketingEntity) -> TicketingCompletionViewController) {
        self.viewModel = viewModel
        self.ticketingCompletionViewControllerFactory = ticketingCompletionViewControllerFactory
        
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
        self.bindViewModel()
        self.bindUIComponents()
    }
}

// MARK: - Methods

extension TicketingConfirmViewController {
    
    private func bindViewModel() {
        self.viewModel.output.navigateToCompletion
            .subscribe(with: self) { owner, _ in
                owner.dismiss(animated: true) {
                    let viewController = owner.ticketingCompletionViewControllerFactory(self.viewModel.ticketingEntity)
                    owner.navigationController?.pushViewController(viewController, animated: true)
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
        self.view.backgroundColor = .grey95.withAlphaComponent(0.85)
        
        self.view.addSubview(self.contentBackGroundView)
        self.contentBackGroundView.addSubviews([self.closeButton,
                                                self.titleLabel,
                                                self.infoStackView,
                                                self.payButton])
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
