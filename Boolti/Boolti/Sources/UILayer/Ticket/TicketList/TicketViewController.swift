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
import RxDataSources
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

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .grey95
        tableView.register(ConformingDepositTableViewCell.self, forCellReuseIdentifier: ConformingDepositTableViewCell.className)
        tableView.register(UsedTicketTableViewCell.self, forCellReuseIdentifier: UsedTicketTableViewCell.className)
        tableView.register(UsableTicketTableViewCell.self, forCellReuseIdentifier: UsableTicketTableViewCell.className)
        return tableView
    }()

    private lazy var tableViewDataSource = dataSource()

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
        self.view.backgroundColor = .grey95
        self.navigationController?.navigationBar.isHidden = true
        self.configureUI()
        self.bindViewModel()
    }

    private func configureUI() {
        self.view.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.tableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
//        self.view.addSubview(self.containerView)
//        self.containerView.snp.makeConstraints { make in
//            make.edges.equalTo(self.view.safeAreaLayoutGuide)
//        }

//        self.configureTableView()
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

        self.viewModel.output.sectionModels
            .asDriver(onErrorJustReturn: [])
            .drive(self.tableView.rx.items(dataSource: self.tableViewDataSource))
            .disposed(by: self.disposeBag)

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

    private func dataSource() -> RxTableViewSectionedReloadDataSource<TicketSection> {
        return RxTableViewSectionedReloadDataSource<TicketSection> { dataSource, tableView, indexPath, _ in
            switch dataSource[indexPath] {
            case .conformingDepositTicket(id: let id, title: let title):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ConformingDepositTableViewCell.className, for: indexPath) as? ConformingDepositTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: id, title: title)
                return cell

            case .usableTicket(item: let ticket):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UsableTicketTableViewCell.className, for: indexPath) as? UsableTicketTableViewCell else {
                    return UITableViewCell()
                }
                cell.configureData(with: ticket)
                return cell

            case .usedTicket(item: let ticket):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: UsedTicketTableViewCell.className, for: indexPath) as? UsedTicketTableViewCell else { return UITableViewCell() }
                cell.configureData(with: ticket)
                return cell
            }
        }
    }

    private func createViewController(_ next: TicketViewDestination) -> UIViewController {
        switch next {
        case .login: return loginViewControllerFactory()
        }
    }
}

extension TicketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let section = self.tableViewDataSource[indexPath.section]

        switch section {
        case .conformingDeposit(items: _):
            return 162
        case .usable(items: _):
            return 590
        case .used(items: _):
            return 180
        }
    }
}
