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
    
    private let ticketTypeView = TicketTypeView()
    private let selectedTicketView = SelectedTicketView()
    
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
        self.bindInputs()
        self.bindOutputs()
    }
}

// MARK: - Methods

extension TicketSelectionViewController {
    
    private func bindInputs() {
        self.ticketTypeView.tableView.rx.modelSelected(TicketEntity.self)
            .asDriver()
            .drive(with: self, onNext: { owner, entity  in
                guard entity.inventory > 0 else { return }
                owner.viewModel.input.selectedTickets.accept([entity])
                owner.showContentView(.SelectedTicket)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.input.selectedTickets
            .bind(to: selectedTicketView.tableView.rx.items(cellIdentifier: SelectedTicketTableViewCell.className, cellType: SelectedTicketTableViewCell.self)) { index, item, cell in
                cell.selectionStyle = .none
                cell.setData(entity: item)
                
                cell.didDeleteButtonTap
                    .asDriver()
                    .drive(with: self, onNext: { owner, _ in
                        owner.showContentView(.TicketTypeList)
                    })
                    .disposed(by: cell.disposeBag)
            }.disposed(by: self.disposeBag)
        
        self.selectedTicketView.ticketingButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.tickets
            .bind(to: ticketTypeView.tableView.rx.items(cellIdentifier: TicketTypeTableViewCell.className, cellType: TicketTypeTableViewCell.self)) { index, item, cell in
                cell.selectionStyle = .none
                cell.setData(entity: item)
            }.disposed(by: self.disposeBag)
        
        self.viewModel.output.totalPrice
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self, onNext: { owner, price in
                owner.selectedTicketView.setTotalPriceLabel(price: price)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func showContentView(_ view: BottomSheetContentType) {
        switch view {
        case .TicketTypeList:
            self.ticketTypeView.isHidden = false
            self.selectedTicketView.isHidden = true
            self.configureDetent(contentHeight: CGFloat(self.viewModel.output.tickets.value.count) * self.ticketTypeView.cellHeight, contentType: .TicketTypeList)
        case .SelectedTicket:
            self.ticketTypeView.isHidden = true
            self.selectedTicketView.isHidden = false
            self.configureDetent(contentHeight: CGFloat(self.viewModel.input.selectedTickets.value.count) * self.selectedTicketView.cellHeight + 122, contentType: .SelectedTicket)
        }
    }
}

// MARK: - UI

extension TicketSelectionViewController {
    
    private func configureUI() {
        self.setTitle("티켓 선택")
        
        self.contentView.addSubviews([self.ticketTypeView, self.selectedTicketView])
        self.showContentView(.TicketTypeList)
    }
    
    private func configureConstraints() {
        self.ticketTypeView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.horizontalEdges.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        
        self.selectedTicketView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.horizontalEdges.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
    }
}

enum BottomSheetContentType {
    case TicketTypeList
    case SelectedTicket
}
