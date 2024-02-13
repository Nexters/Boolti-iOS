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
}

// MARK: - UI

extension QRScannerListViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
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
    }
}
