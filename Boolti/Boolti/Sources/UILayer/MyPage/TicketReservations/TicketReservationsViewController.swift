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

    private let viewModel: TicketReservationsViewModel
    private let disposeBag = DisposeBag()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .grey95
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TicketReservationsTableViewCell.self, forCellReuseIdentifier: TicketReservationsTableViewCell.className)
        return tableView
    }()

    private let navigationBar = BooltiNavigationBar(type: .ticketReservations)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindUIComponents()
        self.bindViewModel()
    }

    init(viewModel: TicketReservationsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true

        self.view.addSubviews([
            self.navigationBar,
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

        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
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
                self.viewModel.input.viewWillAppearEvent.accept(())
            })
            .disposed(by: self.disposeBag)
    }

    private func bindOutputs() {
        self.viewModel.output.tickerReservations
            .bind(to: self.tableView.rx.items(
                cellIdentifier: TicketReservationsTableViewCell.className,
                cellType: TicketReservationsTableViewCell.self
            )) { index, item, cell in
                cell.selectionStyle = .none
                cell.setData(with: item)
            }
            .disposed(by: self.disposeBag)
    }
}

extension TicketReservationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 177
    }
}
