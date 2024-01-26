//
//  SelectTicketViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit
import RxSwift
import SnapKit

final class SelectTicketViewController: BooltiBottomSheetViewController {
    
    // MARK: Properties
    
    let viewModel: SelectTicketViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .grey85
        view.separatorStyle = .none
        return view
    }()
    
    // MARK: Init
    init(viewModel: SelectTicketViewModel) {
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
        self.configureDetent(254)
        self.configureTableView()
        self.bindOutputs()
    }
}

// MARK: - Methods

extension SelectTicketViewController {
    
    private func configureTableView() {
        self.tableView.register(SelectTicketTableViewCell.self, forCellReuseIdentifier: SelectTicketTableViewCell.className)
        
        Observable.just(58)
            .bind(to: self.tableView.rx.rowHeight)
            .disposed(by: disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.tickets
            .bind(to: tableView.rx.items(cellIdentifier: SelectTicketTableViewCell.className, cellType: SelectTicketTableViewCell.self)) { index, item, cell in
                cell.selectionStyle = .none
                cell.setData(entity: item)
            }.disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension SelectTicketViewController {
    
    private func configureUI() {
        self.setTitle("티켓 선택")
        
        self.view.addSubview(tableView)
    }
    
    private func configureConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.titleView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
