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
    
    private let viewModel: GiftingDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let businessInfoViewControllerFactory: () -> BusinessInfoViewController
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "선물하기"))
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 0, bottom: 24, right: 0)
        //        view.keyboardDismissMode = .onDrag
        //        view.delegate = self
        return view
    }()
    
    private let selectCardView = SelectCardView()
    
    private let receiverInputView = UserInfoInputView(type: .receiver)
    
    private let senderInputView = UserInfoInputView(type: .sender)
    
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
    
    private let payButton = BooltiButton(title: "\(0.formattedCurrency())원 결제하기")
    
    // MARK: Initailizer
    
    init(viewModel: GiftingDetailViewModel,
         businessInfoViewControllerFactory: @escaping () -> BusinessInfoViewController) {
        self.viewModel = viewModel
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
        self.bindUIComponents()
    }
    
}

// MARK: - Methods

extension GiftingDetailViewController {
    
    private func bindUIComponents() {
        self.bindNavigationBar()
        self.bindConcertTicketInfoView()
        self.bindBusinessInfoView()
        self.bindAgreeView()
    }
    
    private func bindNavigationBar() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindConcertTicketInfoView() {
        self.viewModel.output.concertDetail
            .bind(with: self) { owner, entity in
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
    
}

// MARK: - UI

extension GiftingDetailViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        
        self.view.addSubviews([self.navigationBar,
                               self.scrollView,
                               self.buttonBackgroundView,
                               self.payButton])
        self.scrollView.addSubviews([self.stackView])
        
        self.view.backgroundColor = .grey95
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
    }
    
}
