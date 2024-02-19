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
    private let reportViewControllerFactory: () -> ReportViewController
    private let ticketSelectionViewControllerFactory: (ConcertId) -> TicketSelectionViewController
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .concertDetail)
    
    private let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black100.withAlphaComponent(0.85)
        view.isHidden = true

        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
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
        let view = UIView()

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 24)
        gradient.colors = [UIColor.grey95.withAlphaComponent(0.0).cgColor, UIColor.grey95.cgColor]
        gradient.locations = [0.1, 0.7]
        view.layer.insertSublayer(gradient, at: 0)

        return view
    }()
    
    private let ticketingButton = BooltiButton(title: "예매하기")
    
    // MARK: Init
    
    init(viewModel: ConcertDetailViewModel,
         loginViewControllerFactory: @escaping () -> LoginViewController,
         concertContentExpandViewControllerFactory: @escaping (Content) -> ConcertContentExpandViewController,
         reportViewControllerFactory: @escaping () -> ReportViewController,
         ticketSelectionViewControllerFactory: @escaping (ConcertId) -> TicketSelectionViewController) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        self.concertContentExpandViewControllerFactory = concertContentExpandViewControllerFactory
        self.reportViewControllerFactory = reportViewControllerFactory
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
        self.viewModel.fetchConcertDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.dimmedBackgroundView.isHidden = true
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
                owner.ticketingButton.isEnabled = state.isEnabled
                owner.ticketingButton.setTitle(state.title, for: .normal)
                owner.ticketingButton.setTitleColor(state.titleColor, for: .normal)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.navigate
            .asDriver(onErrorJustReturn: .login)
            .drive(with: self) { owner, destination in
                switch destination {
                case .login:
                    let viewController = owner.loginViewControllerFactory()
                    viewController.modalPresentationStyle = .overFullScreen
                    owner.present(viewController, animated: true)
                case .contentExpand(let content):
                    let viewController = owner.concertContentExpandViewControllerFactory(content)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .ticketSelection(let concertId):
                    let viewController = owner.ticketSelectionViewControllerFactory(concertId)
                    viewController.isDismissed = {
                        owner.dimmedBackgroundView.isHidden = true
                    }
                    
                    owner.dimmedBackgroundView.isHidden = false
                    owner.present(viewController, animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindUIComponents() {
        self.bindPlaceInfoView()
        self.bindContentInfoView()
        self.bindNavigationBar()
    }
    
    private func bindPlaceInfoView() {
        self.placeInfoView.didAddressCopyButtonTap()
            .emit(with: self) { owner, _ in
                UIPasteboard.general.string = owner.viewModel.output.concertDetailEntity?.streetAddress
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
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationBar.didHomeButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationBar.didShareButtonTap()
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
        
        self.navigationBar.didMoreButtonTap()
            .emit(with: self) { owner, _ in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                let reportAction = UIAlertAction(title: "신고하기", style: .default) { _ in
                    let viewController = owner.reportViewControllerFactory()
                    owner.navigationController?.pushViewController(viewController, animated: true)
                 }
                 alertController.addAction(reportAction)

                let cancleAction = UIAlertAction(title: "취소하기", style: .cancel)
                alertController.addAction(cancleAction)

                owner.present(alertController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UIScrollViewDelegate

extension ConcertDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset <= self.concertPosterView.frame.height {
            self.navigationBar.setBackgroundColor(with: .grey90)
        } else {
            self.navigationBar.setBackgroundColor(with: .grey95)
        }
    }
}

// MARK: - UI

extension ConcertDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.scrollView,
                               self.buttonBackgroundView,
                               self.ticketingButton,
                               self.dimmedBackgroundView])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
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
            make.height.equalTo(24)
        }
        
        self.ticketingButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
