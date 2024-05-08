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
    private let logoutViewControllerFactory: () -> LogoutViewController
    private let resignInfoViewControllerFactory: () -> ResignInfoViewController
    private let ticketReservationsViewControllerFactory: () -> TicketReservationsViewController
    private let qrScanViewControllerFactory: () -> QRScannerListViewController

    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel

    private let profileView = MypageProfileView()
    private let ticketingReservationsNavigationView = MypageContentView(title: "예매 내역")
    private let registerConcertView = MypageContentView(title: "공연 등록")
    private let qrScannerListNavigationView = MypageContentView(title: "QR 스캔")
    private let logoutNavigationView = MypageContentView(title: "로그아웃")

    private let resignNavigationButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 탈퇴", for: .normal)
        button.setUnderline(font: .pretendardR(14), textColor: .grey60)
        button.isHidden = true

        return button
    }()

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
        logoutViewControllerFactory: @escaping () -> LogoutViewController,
        resignInfoViewControllerFactory: @escaping () -> ResignInfoViewController,
        ticketReservationsViewControllerFactory: @escaping () -> TicketReservationsViewController,
        qrScanViewControllerFactory: @escaping () -> QRScannerListViewController
    ) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        self.logoutViewControllerFactory = logoutViewControllerFactory
        self.resignInfoViewControllerFactory = resignInfoViewControllerFactory
        self.ticketReservationsViewControllerFactory = ticketReservationsViewControllerFactory
        self.qrScanViewControllerFactory = qrScanViewControllerFactory

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95

        self.view.addSubviews([
            self.profileView,
            self.ticketingReservationsNavigationView,
            self.registerConcertView,
            self.qrScannerListNavigationView,
            self.logoutNavigationView,
            self.resignNavigationButton
        ])

        self.logoutNavigationView.isHidden = true

        self.profileView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        self.ticketingReservationsNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(66)
            make.top.equalTo(self.profileView.snp.bottom)
        }

        self.registerConcertView.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(self.ticketingReservationsNavigationView)
            make.top.equalTo(self.ticketingReservationsNavigationView.snp.bottom).offset(12)
        }

        self.qrScannerListNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(self.ticketingReservationsNavigationView)
            make.top.equalTo(self.registerConcertView.snp.bottom).offset(12)
        }

        self.logoutNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.height.equalTo(self.ticketingReservationsNavigationView)
            make.top.equalTo(self.qrScannerListNavigationView.snp.bottom).offset(12)
        }

        self.resignNavigationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(40)
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

        self.logoutNavigationView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didLogoutButtonTapEvent.onNext(())
            }
            .disposed(by: self.disposeBag)

        // TODO: 임시로 회원 탈퇴 로그아웃 처리
        self.resignNavigationButton.rx.tap
            .bind(to: self.viewModel.input.didResignButtonTapEvent)
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
                    owner.updateProfileUI()
                } else {
                    owner.profileView.resetProfileUI()
                    owner.resetProfileUI()
                }
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.navigation
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self, onNext: { owner, destination in
                let viewController = owner.createViewController(destination)
                switch destination {
                case .login, .logout:
                    viewController.modalPresentationStyle = .fullScreen
                    owner.present(viewController, animated: true)
                case .ticketReservations, .qrScannerList, .resign:
                    owner.navigationController?.pushViewController(viewController, animated: true)
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func updateProfileUI() {
        self.resignNavigationButton.isHidden = false
        self.logoutNavigationView.isHidden = false
    }

    private func resetProfileUI() {
        self.resignNavigationButton.isHidden = true
        self.logoutNavigationView.isHidden = true
    }


    private func createViewController(_ next: MyPageDestination) -> UIViewController {
        switch next {
        case .login: return loginViewControllerFactory()
        case .logout: return logoutViewControllerFactory()
        case .resign: return resignInfoViewControllerFactory()
        case .qrScannerList: return qrScanViewControllerFactory()
        case .ticketReservations: return ticketReservationsViewControllerFactory()
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
