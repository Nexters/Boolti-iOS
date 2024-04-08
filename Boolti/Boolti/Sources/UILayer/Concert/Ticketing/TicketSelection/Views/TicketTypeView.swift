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
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .subhead2
        label.text = "옵션 선택"
        return label
    }()

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
        self.addSubviews([self.titleLabel,
                          self.tableView])
    }

    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
