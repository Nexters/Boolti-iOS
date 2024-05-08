//
//  TicketReservationsViewController.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import UIKit

import RxCocoa
import RxSwift
import RxAppState
import RxDataSources

final class TicketReservationsViewController: BooltiViewController {

    typealias ReservationID = String

    private let ticketReservationDetailViewControllerFactory: (ReservationID) -> TicketReservationDetailViewController

    private let viewModel: TicketReservationsViewModel

    private let disposeBag = DisposeBag()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .grey95
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TicketReservationsTableViewCell.self, forCellReuseIdentifier: TicketReservationsTableViewCell.className)
        return tableView
    }()

    private let emptyReservationsStackView: EmptyReservationsStackView = {
        let stackView = EmptyReservationsStackView()
        stackView.isHidden = true

        return stackView
    }()

    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "예매 내역"))

    init(ticketReservationDetailViewControllerFactory: @escaping (ReservationID) -> TicketReservationDetailViewController,viewModel: TicketReservationsViewModel) {
        self.viewModel = viewModel
        self.ticketReservationDetailViewControllerFactory = ticketReservationDetailViewControllerFactory
        super.init()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        self.configureLandingDestination()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUIComponents()
        self.bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.navigationController?.navigationBar.isHidden = true

        self.view.addSubviews([
            self.navigationBar,
            self.emptyReservationsStackView,
            self.tableView
        ])

        self.configureConstraints()

        self.tableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }

    private func configureConstraints() {

        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.emptyReservationsStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.tableView.rx.modelSelected(TicketReservationItemEntity.self)
            .asDriver()
            .drive(with: self) { owner, ticketReservationItemEntity in
                let viewController = owner.ticketReservationDetailViewControllerFactory(String(ticketReservationItemEntity.reservationID))
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {
        self.bindInputs()
        self.bindOutputs()
    }

    private func bindInputs() {
        self.rx.viewWillAppear
            .bind(with: self, onNext: { owner, _ in
                owner.viewModel.input.viewWillAppearEvent.accept(())
            })
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {
        self.viewModel.output.tickerReservations
            .flatMap({ [weak self] ticketReservations in
                if ticketReservations.isEmpty {
                    self?.emptyReservationsStackView.isHidden = false
                    self?.tableView.isHidden = true
                }
                return Observable.just(ticketReservations)
            })
            .bind(to: self.tableView.rx.items(
                cellIdentifier: TicketReservationsTableViewCell.className,
                cellType: TicketReservationsTableViewCell.self
            )) { index, item, cell in
                cell.selectionStyle = .none
                cell.setData(with: item)
            }
            .disposed(by: self.disposeBag)
    }

    func configureLandingDestination() {
        guard let landingDestination = UserDefaults.landingDestination else { return }

        if case .reservationDetail(let reservationID) = landingDestination {
            UserDefaults.landingDestination = nil // 할일 다하면 nil로 설정하기
            let viewController = self.ticketReservationDetailViewControllerFactory("\(reservationID)")
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension TicketReservationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 177
    }
}
