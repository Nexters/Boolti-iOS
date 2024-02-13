//
//  QRScannerViewController.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import UIKit

import RxSwift

final class QRScannerListViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: QRScannerListViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .qrScannerList)
    
    private lazy var emtpyLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.addArrangedSubviews([self.emptyMainTitle, self.emptySubTitle])
        return stackView
    }()
    
    private let emptyMainTitle: UILabel = {
        let label = UILabel()
        label.text = "주최한 공연이 없어요"
        label.font = .headline1
        label.textColor = .grey05
        return label
    }()
    
    private let emptySubTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .body3
        label.textColor = .grey30
        label.text = "공연을 주최하고 QR 스캐너로\n관객 입장을 관리해 보세요"
        label.setLineSpacing(lineSpacing: 6)
        label.textAlignment = .center
        return label
    }()
    
    private let scannerTableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .grey95
        return tableView
    }()
    
    // MARK: Init

    init(viewModel: QRScannerListViewModel) {
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
        self.bindNavigationBar()
        self.bindScannerTableView()
        
        self.viewModel.output.qrScanners.accept([QRScannerEntity(concertId: 0, concertName: "2024 TOGETHER LUCKY Club", concertEndDatetime: Date(), entranceCode: "1234"), QRScannerEntity(concertId: 2, concertName: "일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십일이삼사오육칠팔구십", concertEndDatetime: Date(), entranceCode: "123433")])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        // scanner data fetch
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Methods

extension QRScannerListViewController {
    
    private func bindNavigationBar() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindScannerTableView() {
        self.scannerTableView.register(QRScannerListTableViewCell.self, forCellReuseIdentifier: QRScannerListTableViewCell.className)

        Observable.just(104)
            .bind(to: self.scannerTableView.rx.rowHeight)
            .disposed(by: disposeBag)
        
        self.viewModel.output.qrScanners
            .do { self.emtpyLabelStackView.isHidden = !$0.isEmpty }
            .bind(to: self.scannerTableView.rx.items(cellIdentifier: QRScannerListTableViewCell.className, cellType: QRScannerListTableViewCell.self)) { index, item, cell in
                cell.selectionStyle = .none
                cell.setData(concertName: item.concertName)
            }
            .disposed(by: self.disposeBag)
        
        self.scannerTableView.rx.modelSelected(QRScannerEntity.self)
            .asDriver()
            .drive(with: self) { owner, qrScannerEntity in
                debugPrint(qrScannerEntity)
                
                // TODO: qr 화면으로 이동
//                let viewController = owner.ticketReservationDetailViewControllerFactory(String(ticketReservationItemEntity.reservationID))
//                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension QRScannerListViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.scannerTableView,
                               self.emtpyLabelStackView])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.emtpyLabelStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.scannerTableView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
