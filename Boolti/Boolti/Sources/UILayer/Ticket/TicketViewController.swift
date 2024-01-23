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

final class TicketViewController: ViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: TicketViewModel

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    private let loginEnterView: LoginEnterView = {
        let view = LoginEnterView()

        return view
    }()

    init(viewModel: TicketViewModel) {
        self.viewModel = viewModel
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
        self.bind()
    }

    private func configureUI() {
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

    }

    private func bind() {

        self.rx.viewWillAppear
            .take(1)
            .flatMapFirst { _ in self.viewModel.navigation }
            .subscribe(with: self, onNext: { owner, ticketDestination in
                let viewController = self.createViewController(ticketDestination)
                switch ticketDestination {
                case .login:
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)
                }
            })
            .disposed(by: self.disposeBag)

        self.rx.viewDidAppear
            .subscribe(with: self) { owner, _ in
                self.viewModel.loadAccessToken()
            }
            .disposed(by: self.disposeBag)

        self.viewModel.isAccessTokenLoaded
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, isLoaded in
                if isLoaded {
                    // 여기서 그냥 API 호출해서 원래대로 화면 보여주기!..
                }
                self.containerView.addSubview(self.loginEnterView)
                self.configureLoginEnterView()
            }
            .disposed(by: self.disposeBag)

        //        self.viewModel.isLoading
        //            .distinctUntilChanged()
        //            .bind(to: self.isLoading)
        //            .disposed(by: self.disposeBag)
    }

    private func configureLoginEnterView() {
        self.loginEnterView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


    private func createViewController(_ next: TicketViewDestination) -> UIViewController {
        switch next {
        case .login: return LoginViewController()
        }
    }
}
