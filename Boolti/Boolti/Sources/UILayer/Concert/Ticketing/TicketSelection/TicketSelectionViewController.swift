//
//  TicketSelectionViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit

import RxSwift
import SnapKit

enum BottomSheetContentType {
    case ticketTypeList
    case selectedSalesTicket
    case selectedInvitationTicket
}

final class TicketSelectionViewController: BooltiViewController {
    
    // MARK: Properties
    
    let viewModel: TicketSelectionViewModel
    private let disposeBag = DisposeBag()
    private let ticketingDetailViewControllerFactory: (SelectedTicketEntity) -> TicketingDetailViewController
    private let giftingDetailViewControllerFactory: (SelectedTicketEntity) -> GiftingDetailViewController
    var onDismiss: (() -> ())?
    
    // MARK: UI Component
    
    private let ticketTypeView = TicketTypeView()
    private let selectedSalesTicketView = SelectedSalesTicketView()
    private let selectedInvitationTicketView = SelectedInvitationTicketView()
    
    // MARK: Init
    
    init(viewModel: TicketSelectionViewModel,
         ticketingDetailViewControllerFactory: @escaping (SelectedTicketEntity) -> TicketingDetailViewController,
         giftingDetailViewControllerFactory: @escaping (SelectedTicketEntity) -> GiftingDetailViewController) {
        self.viewModel = viewModel
        self.ticketingDetailViewControllerFactory = ticketingDetailViewControllerFactory
        self.giftingDetailViewControllerFactory = giftingDetailViewControllerFactory
        
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
        self.configureDefaultBottomSheet()
        self.configureLoadingIndicatorView()
        self.bindInputs()
        self.bindOutputs()
        
        self.sheetPresentationController?.detents = [.custom { _ in return 200}]
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchSalesTicket()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.onDismiss?()
    }
}

// MARK: - Methods

extension TicketSelectionViewController {
    
    private func setDetent(contentHeight: CGFloat) {
        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom { _ in
                    return min(contentHeight, 484)
                }
            ]
        }
    }
    
    private func bindInputs() {
        self.ticketTypeView.tableView.rx.modelSelected(SelectedTicketEntity.self)
            .asDriver()
            .drive(with: self, onNext: { owner, entity  in
                guard entity.quantity > 0 else { return }
                
                owner.viewModel.input.selectedTicket.accept(entity)
                owner.showContentView(entity.ticketType == .sale ? .selectedSalesTicket : .selectedInvitationTicket)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.input.selectedTicket
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self) { owner, entity in
                guard let entity = entity else { return }
                
                switch entity.ticketType {
                case .sale:
                    owner.selectedSalesTicketView.setData(entity: entity)
                case .invitation:
                    owner.selectedInvitationTicketView.setData(entity: entity)
                }
            }.disposed(by: self.disposeBag)
        
        self.viewModel.input.ticketCount
            .asDriver()
            .drive(with: self) { owner, count in
                guard let selectedTicket = owner.viewModel.input.selectedTicket.value else { return }
                owner.selectedSalesTicketView.setCount(price: selectedTicket.price, count: count, maxCount: selectedTicket.quantity)
            }.disposed(by: self.disposeBag)
        
        self.selectedSalesTicketView.ticketingButton.rx.tap
            .bind(to: self.viewModel.input.didTicketingButtonTap)
            .disposed(by: self.disposeBag)
        
        self.selectedInvitationTicketView.ticketingButton.rx.tap
            .bind(to: self.viewModel.input.didTicketingButtonTap)
            .disposed(by: self.disposeBag)
        
        self.selectedSalesTicketView.didMinusButtonTap
            .asDriver()
            .drive(with: self) { owner, _ in
                let count = owner.viewModel.input.ticketCount.value - 1
                owner.viewModel.input.ticketCount.accept(count)
            }
            .disposed(by: self.disposeBag)
        
        self.selectedSalesTicketView.didPlusButtonTap
            .asDriver()
            .drive(with: self) { owner, _ in
                let count = owner.viewModel.input.ticketCount.value + 1
                owner.viewModel.input.ticketCount.accept(count)
            }
            .disposed(by: self.disposeBag)
        
        self.selectedSalesTicketView.didDeleteButtonTap
            .bind(to: self.viewModel.input.didDeleteButtonTap)
            .disposed(by: self.disposeBag)
        
        self.selectedInvitationTicketView.didDeleteButtonTap
            .bind(to: self.viewModel.input.didDeleteButtonTap)
            .disposed(by: self.disposeBag)
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
        
        self.viewModel.output.showTicketTypeView
            .asDriver(onErrorJustReturn: ())
            .drive(with: self, onNext: { owner, _ in
                owner.showContentView(.ticketTypeList)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.didSalesTicketFetched
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.showContentView(.ticketTypeList)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.navigateTicketingDetail
            .bind(with: self) { owner, entity in
                               
                var viewController: BooltiViewController
                switch owner.viewModel.type {
                case .ticketing:
                    viewController = owner.ticketingDetailViewControllerFactory(entity)
                case .gifting:
                    viewController = owner.giftingDetailViewControllerFactory(entity)
                }

                guard let presentingViewController = owner.presentingViewController as? HomeTabBarController else { return }
                guard let rootviewController = presentingViewController.children[0] as? UINavigationController else { return }

                owner.dismiss (animated: true) {
                    rootviewController.pushViewController(viewController, animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func showContentView(_ view: BottomSheetContentType) {
        switch view {
        case .ticketTypeList:
            self.ticketTypeView.isHidden = false
            self.selectedSalesTicketView.isHidden = true
            self.selectedInvitationTicketView.isHidden = true
            
            self.setDetent(contentHeight: 80 + CGFloat(self.viewModel.output.salesTickets.value.count) * self.ticketTypeView.cellHeight + 20)
        case .selectedSalesTicket:
            self.ticketTypeView.isHidden = true
            self.selectedSalesTicketView.isHidden = false
            self.selectedInvitationTicketView.isHidden = true
            
            self.setDetent(contentHeight: 276)
        case .selectedInvitationTicket:
            self.ticketTypeView.isHidden = true
            self.selectedSalesTicketView.isHidden = true
            self.selectedInvitationTicketView.isHidden = false
            
            self.setDetent(contentHeight: 260)
        }
    }
}

// MARK: - UI

extension TicketSelectionViewController {
    
    private func configureDefaultBottomSheet() {
        if let sheet = sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = .grey85
        
        self.view.addSubviews([self.ticketTypeView,
                                      self.selectedSalesTicketView,
                                      self.selectedInvitationTicketView])
        self.selectedSalesTicketView.isHidden = true
        self.selectedInvitationTicketView.isHidden = true
    }
    
    private func configureConstraints() {
        [self.ticketTypeView,
         self.selectedSalesTicketView,
         self.selectedInvitationTicketView].forEach { view in
            view.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(40)
                make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            
        }
    }
}
