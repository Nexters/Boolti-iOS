//
//  TicketSelectionViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit
import RxSwift
import SnapKit

final class TicketSelectionViewController: BooltiBottomSheetViewController {
    
    // MARK: Properties
    
    let viewModel: TicketSelectionViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .grey85
        view.separatorStyle = .none
        return view
    }()
    
    // MARK: Init
    init(viewModel: TicketSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.configureTableView()
        self.bindOutputs()
    }
}

// MARK: - Methods

extension TicketSelectionViewController {
    
    private func configureTableView() {
        self.tableView.register(TicketSelectionTableViewCell.self, forCellReuseIdentifier: TicketSelectionTableViewCell.className)
        
        Observable.just(58)
            .bind(to: self.tableView.rx.rowHeight)
            .disposed(by: disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.tickets
            .bind(to: tableView.rx.items(cellIdentifier: TicketSelectionTableViewCell.className, cellType: TicketSelectionTableViewCell.self)) { index, item, cell in
                cell.selectionStyle = .none
                cell.setData(entity: item)
            }.disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension TicketSelectionViewController {
    
    private func configureUI() {
        self.setTitle("티켓 선택")
        self.configureDetent(contentHeight: CGFloat(self.viewModel.output.tickets.value.count * 58))
        
        self.contentView.addSubview(tableView)
    }
    
    private func configureConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.horizontalEdges.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }
}