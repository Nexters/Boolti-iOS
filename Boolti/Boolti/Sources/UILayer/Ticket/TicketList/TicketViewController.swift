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

    private let loginViewControllerFactory: () -> LoginViewController

    private let viewModel: TicketViewModel
    private let disposeBag = DisposeBag()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .grey95
        tableView.register(ConformingDepositTableViewCell.self, forCellReuseIdentifier: ConformingDepositTableViewCell.className)
        tableView.register(UsedTicketTableViewCell.self, forCellReuseIdentifier: UsedTicketTableViewCell.className)
        tableView.register(UsableTicketTableViewCell.self, forCellReuseIdentifier: UsableTicketTableViewCell.className)
        return tableView
    }()

    private lazy var tableViewDataSource = self.dataSource()

    private let loginEnterView: LoginEnterView = {
        let view = LoginEnterView()

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
        self.view.backgroundColor = .grey95
        self.navigationController?.navigationBar.isHidden = true
        self.configureUI()
        self.bindViewModel()
    }

    private func configureUI() {
        self.view.addSubview(self.tableView)

        self.tableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)

        self.tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    private func bindViewModel() {
        self.bindInput()
        self.bindOutput()
    }
    
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
            .drive(self.viewModel.input.didloginButtonTapEvent)
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {

        self.viewModel.output.isAccessTokenLoaded
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, isLoaded in
                guard !isLoaded else { return }
                // accessToken이 없으므로 Login 화면으로 가기!..
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.sectionModels
            .asDriver(onErrorJustReturn: [])
            .drive(self.tableView.rx.items(dataSource: self.tableViewDataSource))
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

    private func dataSource() -> RxTableViewSectionedReloadDataSource<TicketSection> {
        return RxTableViewSectionedReloadDataSource<TicketSection> { dataSource, tableView, indexPath, _ in
            switch dataSource[indexPath] {
            case .conformingDepositTicket(id: let id, title: let title):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ConformingDepositTableViewCell.className,
                    for: indexPath
                ) as? ConformingDepositTableViewCell else { return UITableViewCell() }

                cell.setData(with: id, title: title)
                cell.selectionStyle = .none
                return cell

            case .usableTicket(item: let ticket):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: UsableTicketTableViewCell.className,
                    for: indexPath
                ) as? UsableTicketTableViewCell else { return UITableViewCell() }

                cell.setData(with: ticket)
                cell.selectionStyle = .none
                return cell

            case .usedTicket(item: let ticket):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: UsedTicketTableViewCell.className,
                    for: indexPath
                ) as? UsedTicketTableViewCell else { return UITableViewCell() }

                cell.setData(with: ticket)
                cell.selectionStyle = .none
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
