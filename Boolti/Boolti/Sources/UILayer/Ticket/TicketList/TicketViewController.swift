//
//  TicketViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit
import RxCocoa
import RxSwift
import RxAppState
import SnapKit

final class TicketViewController: BooltiViewController {

    private let viewModel: TicketViewModel
    private let loginViewControllerFactory: () -> LoginViewController

    private let disposeBag = DisposeBag()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private let loginEnterView: LoginEnterView = {
        let view = LoginEnterView()

        return view
    }()

    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .red

        return view
    }()

    init(
        viewModel: TicketViewModel,
        loginViewControllerFactory: @escaping () -> LoginViewController
    ) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: 화면 넘어가는 거 확인용. 나중에 지워야함!
        self.view.backgroundColor = .green
        self.configureUI()
        self.bindViewModel()
    }

    private func configureUI() {
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func bindViewModel() {
        self.bindInput()
        self.bindOutput()
    }
    
    // VC에서 일어나는 Input을 binding한다.
    private func bindInput() {
        self.rx.viewDidAppear
            .take(1)
            .asDriver(onErrorJustReturn: true)
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.input.viewDidAppearEvent.onNext(())
            })
            .disposed(by: self.disposeBag)

        self.loginEnterView.loginButton.rx.tap
            .asDriver()
            .drive(self.viewModel.input.loginButtonTapEvent)
            .disposed(by: self.disposeBag)
    }

    // ViewModel의 Output을 Binding한다.
    private func bindOutput() {
        self.viewModel.output.isAccessTokenLoaded
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, isLoaded in
                if isLoaded {
                    // 여기서 그냥 API 호출해서 원래대로 화면 보여주기!..
                } else {
                    // 여기는 token이 없으므로 loginEnterView를 보여주기!...
                    owner.containerView.addSubview(owner.loginEnterView)
                    owner.configureLoginEnterView()
                }
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.navigation
            .subscribe(with: self) { owner, ticketDestination in
                let viewController = owner.createViewController(ticketDestination)

                if let viewController = viewController as? LoginViewController {
                    viewController.hidesBottomBarWhenPushed = true
                    viewController.modalPresentationStyle = .fullScreen
                    owner.present(viewController, animated: true)
                } else {
                    owner.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func configureLoginEnterView() {
        self.loginEnterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func createViewController(_ next: TicketViewDestination) -> UIViewController {
        switch next {
        case .login: return loginViewControllerFactory()
        }
    }
}