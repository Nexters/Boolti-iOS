//
//  TicketTypeView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit

import RxSwift

final class TicketTypeView: UIView {

    // MARK: Properties

    private let disposeBag = DisposeBag()
    let cellHeight: CGFloat = 58

    // MARK: - UI Component

    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .grey85
        view.separatorStyle = .none
        return view
    }()

    // MARK: Init

    init() {
        super.init(frame: .zero)

        self.configureUI()
        self.configureConstraints()
        self.configureTableView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension TicketTypeView {

    private func configureTableView() {
        self.tableView.register(TicketTypeTableViewCell.self, forCellReuseIdentifier: TicketTypeTableViewCell.className)

        Observable.just(self.cellHeight)
            .bind(to: self.tableView.rx.rowHeight)
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension TicketTypeView {

    private func configureUI() {
        self.addSubview(tableView)
    }

    private func configureConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}
