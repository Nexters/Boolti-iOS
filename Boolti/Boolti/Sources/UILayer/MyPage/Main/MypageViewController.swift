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

final class MyPageViewController: UIViewController {

    private let loginViewControllerFactory: () -> LoginViewController
    private let logoutViewControllerFactory: () -> LogoutViewController
    private let resignViewControllerFactory: () -> ResignViewController
    private let ticketReservationsViewControllerFactory: () -> TicketReservationsViewController
    private let qrScanViewControllerFactory: () -> QRScannerListViewController

    private let disposeBag = DisposeBag()
    private let viewModel: MyPageViewModel

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .grey80
        imageView.clipsToBounds = true

        return imageView
    }()

    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "불티 로그인 하러가기"
        label.font = .subhead2
        label.textColor = .grey10

        return label
    }()

    private let profileEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "원하는 공연 티켓을 예매해보세요!"
        label.font = .body3
        label.textColor = .grey30

        return label
    }()

    private let loginNavigationButton: UIButton = {
        let button = UIButton()
        button.setImage(.navigate, for: .normal)

        return button
    }()

    private let logoutNavigationButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setUnderline(font: .pretendardR(14), textColor: .grey50)
        button.isHidden = true

        return button
    }()

    private let ticketingReservationsNavigationView = MypageContentView(title: "예매 내역")
    private let qrScannerListNavigationView = MypageContentView(title: "QR 스캔")
    private let resignNavigationView = MypageContentView(title: "회원 탈퇴")

    override func viewWillLayoutSubviews() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUIComponents()
        self.bindViewModel()
    }

    init(
        viewModel: MyPageViewModel,
        loginViewControllerFactory: @escaping () -> LoginViewController,
        logoutViewControllerFactory: @escaping () -> LogoutViewController,
        resignViewControllerFactory: @escaping () -> ResignViewController,
        ticketReservationsViewControllerFactory: @escaping () -> TicketReservationsViewController,
        qrScanViewControllerFactory: @escaping () -> QRScannerListViewController
    ) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        self.logoutViewControllerFactory = logoutViewControllerFactory
        self.resignViewControllerFactory = resignViewControllerFactory
        self.ticketReservationsViewControllerFactory = ticketReservationsViewControllerFactory
        self.qrScanViewControllerFactory = qrScanViewControllerFactory
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.view.backgroundColor = .black100

        self.view.addSubviews([
            self.profileImageView,
            self.profileNameLabel,
            self.profileEmailLabel,
            self.loginNavigationButton,
            self.ticketingReservationsNavigationView,
            self.qrScannerListNavigationView,
            self.resignNavigationView,
            self.logoutNavigationButton
        ])
        
        self.resignNavigationView.isHidden = true

        self.profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
        }

        self.profileNameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.profileImageView.snp.right).offset(12)
            make.top.equalTo(self.profileImageView.snp.top).offset(8)
        }

        self.profileEmailLabel.snp.makeConstraints { make in
            make.left.equalTo(self.profileNameLabel)
            make.top.equalTo(self.profileNameLabel.snp.bottom).offset(4)
        }

        self.loginNavigationButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalTo(self.profileImageView.snp.centerY)
        }

        self.ticketingReservationsNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(66)
            make.top.equalTo(self.profileImageView.snp.bottom).offset(32)
        }

        self.qrScannerListNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(66)
            make.top.equalTo(self.ticketingReservationsNavigationView.snp.bottom).offset(12)
        }
        
        self.resignNavigationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(66)
            make.top.equalTo(self.qrScannerListNavigationView.snp.bottom).offset(12)
        }

        self.logoutNavigationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(40)
        }
    }

    private func bindUIComponents() {
        self.logoutNavigationButton.rx.tap
            .bind(to: self.viewModel.input.didLogoutButtonTapEvent)
            .disposed(by: self.disposeBag)

        self.loginNavigationButton.rx.tap
            .bind(to: self.viewModel.input.didLoginButtonTapEvent)
            .disposed(by: self.disposeBag)

        self.ticketingReservationsNavigationView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didTicketingReservationsViewTapEvent.onNext(())
            }
            .disposed(by: self.disposeBag)
        
        // TODO: 임시로 회원 탈퇴 로그아웃 처리
        self.resignNavigationView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didResignButtonTapEvent.onNext(())
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
                    owner.updateProfileUI()
                } else {
                    owner.resetProfileUI()
                }
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.navigation
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self, onNext: { owner, destination in
                let viewController = owner.createViewController(destination)
                switch destination {
                case .login, .logout, .resign:
                    viewController.modalPresentationStyle = .fullScreen
                    owner.present(viewController, animated: true)
                case .ticketReservations, .qrScannerList:
                    owner.navigationController?.pushViewController(viewController, animated: true)
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func updateProfileUI() {
        self.loginNavigationButton.isHidden = true
        self.logoutNavigationButton.isHidden = false
        self.resignNavigationView.isHidden = false

        self.profileNameLabel.text =  UserDefaults.userName.isEmpty ? "불티 유저" : UserDefaults.userName
        self.profileEmailLabel.text = UserDefaults.userEmail.isEmpty ? "-" : UserDefaults.userEmail

        let profileImageURLPath = UserDefaults.userImageURLPath

        if profileImageURLPath.isEmpty {
            self.profileImageView.image = .defaultProfile
        } else {
            self.profileImageView.setImage(with: profileImageURLPath)
        }
    }

    private func resetProfileUI() {
        self.logoutNavigationButton.isHidden = true
        self.loginNavigationButton.isHidden = false
        self.resignNavigationView.isHidden = true

        self.profileImageView.image = .defaultProfile
        self.profileNameLabel.text = "불티 로그인 하러가기"
        self.profileEmailLabel.text = "원하는 공연 티켓을 예매해보세요!"
    }


    private func createViewController(_ next: MyPageDestination) -> UIViewController {
        switch next {
        case .login: return loginViewControllerFactory()
        case .logout: return logoutViewControllerFactory()
        case .resign: return resignViewControllerFactory()
        case .qrScannerList: return qrScanViewControllerFactory()
        case .ticketReservations: return ticketReservationsViewControllerFactory()
        }
    }
}
