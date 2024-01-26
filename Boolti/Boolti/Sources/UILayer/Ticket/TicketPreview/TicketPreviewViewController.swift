//
//  TicketPreviewViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/27/24.
//

import UIKit
import RxSwift
import SnapKit

final class TicketPreviewViewController: BooltiBottomSheetViewController {
    
    // MARK: Properties
    
    let viewModel: TicketPreviewViewModel
    private let disposeBag = DisposeBag()
    private let tableViewRowHeight: Int = 94
    
    // MARK: UI Component
    
    private let tableView: UITableView = {
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
    
    private let priceInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "1인 1매"
        label.font = .body3
        label.textColor = .grey30
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .body4
        label.textColor = .orange01
        return label
    }()
    
    private let ticketingButton = BooltiButton(title: "예매하기")
    
    // MARK: Init
    init(viewModel: TicketPreviewViewModel) {
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
        self.bindInputs()
        self.bindOutputs()
    }
}

// MARK: - Methods

extension TicketPreviewViewController {
    
    private func configureTableView() {
        self.tableView.register(TicketPreviewTableViewCell.self, forCellReuseIdentifier: TicketPreviewTableViewCell.className)
        
        Observable.just(self.tableViewRowHeight)
            .map { CGFloat($0) }
            .bind(to: self.tableView.rx.rowHeight)
            .disposed(by: disposeBag)
    }
    
    private func bindInputs() {
        self.ticketingButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
//                owner.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.tickets
            .bind(to: tableView.rx.items(cellIdentifier: TicketPreviewTableViewCell.className, cellType: TicketPreviewTableViewCell.self)) { index, item, cell in
                cell.selectionStyle = .none
                cell.setData(entity: item)
                
                cell.didDeleteButtonTap
                    .asDriver()
                    .drive(with: self, onNext: { owner, _ in
                        
                        // 일단 1인 1매 기준 ticket 선택 내역 없애고 dismiss
                        owner.viewModel.output.tickets.accept([])
                        owner.dismiss(animated: true)
                    })
                    .disposed(by: cell.disposeBag)
            }.disposed(by: self.disposeBag)
        
        self.viewModel.output.totalPrice
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self, onNext: { owner, price in
                self.totalPriceLabel.text = "총 \(price)원"
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension TicketPreviewViewController {
    
    private func configureUI() {
        self.setTitle("티켓 선택")
        self.configureDetent(contentHeight: CGFloat(self.viewModel.output.tickets.value.count * self.tableViewRowHeight + 122))
        
        self.contentView.addSubviews([tableView, underlineView, priceInfoLabel, totalPriceLabel, ticketingButton])
    }
    
    private func configureConstraints() {
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.horizontalEdges.equalTo(self.contentView)
            make.height.equalTo(self.tableViewRowHeight)
            make.bottom.equalTo(self.underlineView.snp.top)
        }
        
        self.underlineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(self.totalPriceLabel.snp.top).offset(-18)
        }
        
        self.priceInfoLabel.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(24)
            make.centerY.equalTo(self.totalPriceLabel)
        }
        
        self.totalPriceLabel.snp.makeConstraints { make in
            make.right.equalTo(self.contentView).offset(-24)
            make.bottom.equalTo(self.ticketingButton.snp.top).offset(-26)
        }
        
        self.ticketingButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.contentView).inset(20)
            make.height.equalTo(48)
            make.bottom.equalTo(self.contentView).inset(8)
        }
    }
}
