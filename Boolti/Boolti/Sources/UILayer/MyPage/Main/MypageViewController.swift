//
//  MyPageViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxAppState
import RxGesture

final class MyPageViewController: BooltiViewController {

    private let loginViewControllerFactory: () -> LoginViewController
    private let ticketReservationsViewControllerFactory: () -> TicketReservationsViewController
    private let qrScanViewControllerFactory: () -> QRScannerListViewController
    private let settingViewControllerFactory: () -> SettingViewController

    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel

    private let profileView = MypageProfileView()
    private let settingNavigationView = MypageContentView(icon: .profile, title: "계정 설정")
    private let ticketingReservationsNavigationView = MypageContentView(icon: .receipt, title: "결제 내역")
    
    private let separateLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        return view
    }()
    
    private let subTitleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "내 공연"
        return label
    }()
    
    private let registerConcertView = MypageContentView(icon: .addConcert, title: "공연 등록")
    private let qrScannerListNavigationView = MypageContentView(icon: .qrScanner, title: "입장 확인")

    private var isAlreadyNavigated = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUIComponents()
        self.bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        self.configureLandingDestination()
    }

    init(
        viewModel: MyPageViewModel,
        loginViewControllerFactory: @escaping () -> LoginViewController,
        ticketReservationsViewControllerFactory: @escaping () -> TicketReservationsViewController,
        qrScanViewControllerFactory: @escaping () -> QRScannerListViewController,
        settingViewControllerFactory: @escaping () -> SettingViewController
    ) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        self.ticketReservationsViewControllerFactory = ticketReservationsViewControllerFactory
        self.qrScanViewControllerFactory = qrScanViewControllerFactory
        self.settingViewControllerFactory = settingViewControllerFactory

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95

        self.view.addSubviews([
            self.profileView,
            self.settingNavigationView,
            self.ticketingReservationsNavigationView,
            self.separateLineView,
            self.subTitleLabel,
            self.registerConcertView,
            self.qrScannerListNavigationView,
        ])

        self.profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.settingNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(self.profileView.snp.bottom).offset(20)
        }

        self.ticketingReservationsNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(self.settingNavigationView)
            make.top.equalTo(self.settingNavigationView.snp.bottom)
        }
        
        self.separateLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.settingNavigationView)
            make.top.equalTo(self.ticketingReservationsNavigationView.snp.bottom).offset(32)
            make.height.equalTo(1)
        }
        
        self.subTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.settingNavigationView)
            make.top.equalTo(self.separateLineView.snp.bottom).offset(32)
        }

        self.registerConcertView.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(self.ticketingReservationsNavigationView)
            make.top.equalTo(self.subTitleLabel.snp.bottom).offset(8)
        }

        self.qrScannerListNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(self.ticketingReservationsNavigationView)
            make.top.equalTo(self.registerConcertView.snp.bottom)
        }
    }

    private func bindUIComponents() {
        self.profileView.rx.tapGesture()
            .when(.recognized)
            .filter{ _ in !self.viewModel.output.isAccessTokenLoaded.value }
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didLoginButtonTapEvent.onNext(())
            }
            .disposed(by: self.disposeBag)
        
        self.settingNavigationView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didSettingViewTapEvent.onNext(())
            }
            .disposed(by: self.disposeBag)

        self.ticketingReservationsNavigationView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didTicketingReservationsViewTapEvent.onNext(())
            }
            .disposed(by: self.disposeBag)

        self.registerConcertView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                guard let url = URL(string: "https://boolti.in/login") else { return }
                UIApplication.shared.open(url, options: [:])
            }
            .disposed(by: self.disposeBag)

        self.qrScannerListNavigationView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didQRScannerListViewTapEvent.onNext(())
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {
        self.bindInputs()
        self.bindOutputs()
    }

    private func bindInputs() {
        self.rx.viewDidAppear
            .bind(with: self, onNext: { owner, destination in
                owner.viewModel.input.viewDidAppearEvent.onNext(())
            })
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {
        self.viewModel.output.isAccessTokenLoaded
            .skip(1)
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isLoaded in
                if isLoaded {
                    owner.profileView.updateProfileUI()
                } else {
                    owner.profileView.resetProfileUI()
                }
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.navigation
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self, onNext: { owner, destination in
                let viewController = owner.createViewController(destination)
                switch destination {
                case .login:
                    viewController.modalPresentationStyle = .fullScreen
                    owner.present(viewController, animated: true)
                case .setting, .ticketReservations, .qrScannerList:
                    owner.navigationController?.pushViewController(viewController, animated: true)
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func createViewController(_ next: MyPageDestination) -> UIViewController {
        switch next {
        case .login: return loginViewControllerFactory()
        case .qrScannerList: return qrScanViewControllerFactory()
        case .ticketReservations: return ticketReservationsViewControllerFactory()
        case .setting: return settingViewControllerFactory()

        }
    }

    func configureLandingDestination() {
        if self.isAlreadyNavigated {
            self.isAlreadyNavigated = false
            return
        }
        guard let landingDestination = UserDefaults.landingDestination else { return }

        if case .reservationList = landingDestination {
            UserDefaults.landingDestination = nil // reservationList가 destination이면 Userdefaults 초기화해주기
        }
 
        let viewController = self.ticketReservationsViewControllerFactory()
        self.navigationController?.pushViewController(viewController, animated: true)
        self.isAlreadyNavigated = true
    }
}
