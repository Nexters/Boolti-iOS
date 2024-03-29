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
    private let ticketingDetailViewControllerFactory: (SelectedTicketEntity) -> TicketingDetailViewController
    var onDismiss: (() -> ())?
    
    // MARK: UI Component
    
    private let ticketTypeView = TicketTypeView()
    private let selectedTicketView = SelectedTicketView()
    
    // MARK: Init
    
    init(viewModel: TicketSelectionViewModel,
         ticketingDetailViewControllerFactory: @escaping (SelectedTicketEntity) -> TicketingDetailViewController) {
        self.viewModel = viewModel
        self.ticketingDetailViewControllerFactory = ticketingDetailViewControllerFactory
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.configureLoadingIndicatorView()
        self.bindInputs()
        self.bindOutputs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchSalesTicket() {
            self.showContentView(.ticketTypeList)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.onDismiss?()
    }
}

// MARK: - Methods

extension TicketSelectionViewController {
    
    private func bindInputs() {
        self.ticketTypeView.tableView.rx.modelSelected(SelectedTicketEntity.self)
            .asDriver()
            .drive(with: self, onNext: { owner, entity  in
                guard entity.quantity > 0 else { return }
                owner.viewModel.input.didTicketSelect.onNext(entity)
                owner.showContentView(.selectedTicket)
            })
            .disposed(by: self.disposeBag)
        
        self.selectedTicketView.ticketingButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.pushTicketingDetailViewController()
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.input.selectedTickets
            .bind(to: selectedTicketView.tableView.rx.items(cellIdentifier: SelectedTicketTableViewCell.className, cellType: SelectedTicketTableViewCell.self)) { [weak self] index, item, cell in
                guard let self else { return }
                cell.selectionStyle = .none
                cell.setData(entity: item)
                
                cell.didDeleteButtonTap
                    .asDriver()
                    .drive(onNext: { _ in
                        self.viewModel.input.didDeleteButtonTap.onNext(item.id)
                    })
                    .disposed(by: cell.disposeBag)
            }.disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.isLoading
            .bind(to: self.isLoading)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.salesTickets
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
        
        self.viewModel.output.showTicketTypeView
            .asDriver(onErrorJustReturn: ())
            .drive(with: self, onNext: { owner, _ in
                owner.showContentView(.ticketTypeList)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func showContentView(_ view: BottomSheetContentType) {
        switch view {
        case .ticketTypeList:
            self.ticketTypeView.isHidden = false
            self.selectedTicketView.isHidden = true
            self.setDetent(contentHeight: CGFloat(self.viewModel.output.salesTicketEntities?.count ?? 0) * self.ticketTypeView.cellHeight, contentType: .ticketTypeList)
        case .selectedTicket:
            self.ticketTypeView.isHidden = true
            self.selectedTicketView.isHidden = false
            self.setDetent(contentHeight: CGFloat(self.viewModel.input.selectedTickets.value.count) * self.selectedTicketView.cellHeight + 122, contentType: .selectedTicket)
        }
    }
    
    private func pushTicketingDetailViewController() {
        
        // 1차 MVP - 티켓 한 개 선택
        guard let selectedTicket = self.viewModel.input.selectedTickets.value.first else { return }
        let viewController = self.ticketingDetailViewControllerFactory(selectedTicket)
        
        guard let presentingViewController = self.presentingViewController as? HomeTabBarController else { return }
        guard let rootviewController = presentingViewController.children[0] as? UINavigationController else { return }
        
        self.dismiss (animated: true) {
            rootviewController.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - UI

extension TicketSelectionViewController {
    
    private func configureUI() {
        self.setTitle("티켓 선택")

        self.contentView.addSubviews([self.ticketTypeView, self.selectedTicketView])
        self.selectedTicketView.isHidden = true
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
