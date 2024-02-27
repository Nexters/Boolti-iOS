//
//  SelectedTicketView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit

import RxSwift

final class SelectedTicketView: UIView {

    // MARK: Properties

    private let disposeBag = DisposeBag()
    let cellHeight: CGFloat = 96

    // MARK: UI Component

    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .grey85
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
        return view
    }()

    private let underlineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .grey80
        return view
    }()

    private let priceInfoLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body3
        label.textColor = .grey30
        label.text = "1인 1매"
        return label
    }()

    private let totalPriceLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body4
        label.textColor = .orange01
        return label
    }()

    let ticketingButton = BooltiButton(title: "예매하기")

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

extension SelectedTicketView {

    private func configureTableView() {
        self.tableView.register(SelectedTicketTableViewCell.self, forCellReuseIdentifier: SelectedTicketTableViewCell.className)

        Observable.just(self.cellHeight)
            .bind(to: self.tableView.rx.rowHeight)
            .disposed(by: disposeBag)
    }

    func setTotalPriceLabel(price: Int) {
        self.totalPriceLabel.text = "총 \(price.formattedCurrency())원"
    }

}

// MARK: - UI

extension SelectedTicketView {

    private func configureUI() {
        self.addSubviews([tableView, underlineView, priceInfoLabel, totalPriceLabel, ticketingButton])
    }

    private func configureConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.underlineView.snp.top)
        }

        self.underlineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(self.totalPriceLabel.snp.top).offset(-18)
        }

        self.priceInfoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalTo(self.totalPriceLabel)
        }

        self.totalPriceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.bottom.equalTo(self.ticketingButton.snp.top).offset(-26)
        }

        self.ticketingButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
