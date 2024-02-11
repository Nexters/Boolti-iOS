//
//  ConcertDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

final class ConcertDetailViewController: BooltiViewController {
    
    // MARK: Properties

    typealias Content = String
    typealias ConcertId = Int
    
    private let viewModel: ConcertDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let loginViewControllerFactory: () -> LoginViewController
    private let concertContentExpandViewControllerFactory: (Content) -> ConcertContentExpandViewController
    private let ticketSelectionViewControllerFactory: (ConcertId) -> TicketSelectionViewController
    
    // MARK: UI Component
    
    private let navigationView = BooltiNavigationBar(type: .concertDetail)

    private let loginEnterView = LoginEnterView()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubviews([self.stackView])
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        stackView.addArrangedSubviews([self.concertPosterView,
                                       self.ticketingPeriodView,
                                       self.datetimeInfoView,
                                       self.placeInfoView,
                                       self.contentInfoView,
                                       self.organizerInfoView])
        
        stackView.setCustomSpacing(40, after: self.concertPosterView)
        return stackView
    }()
    
    private let concertPosterView = ConcertPosterView()
    
    private let ticketingPeriodView = TicketingPeriodView()
    
    private let datetimeInfoView = DatetimeInfoView()
    
    private let placeInfoView = PlaceInfoView()
    
    private let contentInfoView = ContentInfoView()
    
    private let organizerInfoView = OrganizerInfoView()
    
    private lazy var buttonBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 16))
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.grey95.cgColor]
        view.layer.insertSublayer(gradient, at: 0)

        return view
    }()
    
    private let ticketingButton = BooltiButton(title: "예매하기")
    
    // MARK: Init
    
    init(viewModel: ConcertDetailViewModel,
         loginViewControllerFactory: @escaping () -> LoginViewController,
         concertContentExpandViewControllerFactory: @escaping (Content) -> ConcertContentExpandViewController,
         ticketSelectionViewControllerFactory: @escaping (ConcertId) -> TicketSelectionViewController) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        self.concertContentExpandViewControllerFactory = concertContentExpandViewControllerFactory
        self.ticketSelectionViewControllerFactory = ticketSelectionViewControllerFactory
        
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
        self.configureToastView(isButtonExisted: true)
        self.bindUIComponents()
        self.bindInputs()
        self.bindOutputs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Methods

extension ConcertDetailViewController {
    
    private func bindInputs() {
        self.ticketingButton.rx.tap
            .bind(to: self.viewModel.input.didTicketingButtonTap)
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.concertDetail
            .take(1)
            .bind(with: self) { owner, entity in
                owner.concertPosterView.setData(images: entity.posters, title: entity.name)
                owner.ticketingPeriodView.setData(startDate: entity.salesStartTime, endDate: entity.salesEndTime)
                owner.placeInfoView.setData(name: entity.placeName, streetAddress: entity.streetAddress, detailAddress: entity.detailAddress)
                owner.datetimeInfoView.setData(date: entity.date, runningTime: entity.runningTime)
                owner.contentInfoView.setData(content: entity.notice)
                owner.organizerInfoView.setData(hostName: entity.hostName, hostPhoneNumber: entity.hostPhoneNumber)
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.buttonState
            .bind(with: self) { owner, state in
                switch state {
                case .onSale:
                    owner.ticketingButton.isEnabled = true
                    owner.ticketingButton.setTitle(state.rawValue, for: .normal)
                case .beforeSale:
                    owner.ticketingButton.isEnabled = false
                    owner.ticketingButton.setTitle("\(state.rawValue)\(Date().getBetweenDay(to: owner.viewModel.output.concertDetailEntity?.salesStartTime ?? Date()))", for: .normal)
                    owner.ticketingButton.setTitleColor(.orange01, for: .normal)
                case .endSale, .endConcert:
                    owner.ticketingButton.isEnabled = false
                    owner.ticketingButton.setTitle(state.rawValue, for: .normal)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.showLoginEnterView
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, show in
                owner.loginEnterView.isHidden = !show
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.navigate
            .asDriver(onErrorJustReturn: .login)
            .drive(with: self) { owner, destination in
                switch destination {
                case .login:
                    let viewController = owner.loginViewControllerFactory()
                    viewController.modalPresentationStyle = .overFullScreen
                    owner.present(viewController, animated: true) {
                        owner.loginEnterView.isHidden = true
                    }
                case .contentExpand(let content):
                    let viewController = owner.concertContentExpandViewControllerFactory(content)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .ticketSelection(let concertId):
                    let viewController = owner.ticketSelectionViewControllerFactory(concertId)
                    owner.present(viewController, animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindUIComponents() {
        self.bindLoginEnterView()
        self.bindPlaceInfoView()
        self.bindContentInfoView()
        self.bindNavigationBar()
    }
    
    private func bindLoginEnterView() {
        self.loginEnterView.loginButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.output.navigate.accept(.login)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindPlaceInfoView() {
        self.placeInfoView.didAddressCopyButtonTap()
            .emit(with: self) { owner, _ in
                UIPasteboard.general.string = self.viewModel.output.concertDetailEntity?.streetAddress
                owner.showToast(message: "공연장 주소가 복사되었어요")
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindContentInfoView() {
        self.contentInfoView.didAddressExpandButtonTap()
            .emit(with: self) { owner, _ in
                owner.viewModel.input.didExpandButtonTap.accept(())
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindNavigationBar() {
        self.navigationView.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationView.didHomeButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationView.didShareButtonTap()
            .emit(with: self) { owner, _ in
                guard let url = URL(string: AppInfo.booltiShareLink),
                      let posterURL = owner.viewModel.output.concertDetailEntity?.posters.first?.path
                else { return }
                
                let image = KFImage(URL(string: posterURL))
                
                let activityViewController = UIActivityViewController(activityItems: [url, image], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = owner.view
                owner.present(activityViewController, animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationView.didMoreButtonTap()
            .emit(with: self) { owner, _ in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                let reportAction = UIAlertAction(title: "신고하기", style: .default) { _ in
                    // TODO: 신고하기 페이지로 이동
                    debugPrint("신고하기 페이지로 이동")
                 }
                 alertController.addAction(reportAction)

                let cancleAction = UIAlertAction(title: "취소하기", style: .cancel)
                alertController.addAction(cancleAction)

                owner.present(alertController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension ConcertDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationView,
                               self.scrollView,
                               self.buttonBackgroundView,
                               self.ticketingButton,
                               self.loginEnterView])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.loginEnterView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.ticketingButton.snp.top)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalTo(self.scrollView)
        }
        
        self.buttonBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(self.ticketingButton.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(16)
        }
        
        self.ticketingButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
