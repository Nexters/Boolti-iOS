//
//  TicketRefundBankSelectionViewController.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

import RxSwift
import RxCocoa

class TicketRefundBankSelectionViewController: BooltiViewController {

    private let disposeBag = DisposeBag()

    private let titleView: UIView = {
        let view = UIView()
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "은행 선택"
        label.textColor = .grey10
        label.font = .subhead2
        return label
    }()

    private let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .grey85
        collectionView.register(TicketRefundBankCollectionViewCell.self, forCellWithReuseIdentifier: TicketRefundBankCollectionViewCell.className)
        return collectionView
    }()


    let contentView: UIView = {
        let view = UIView()
        return view
    }()

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        self.configureConstraints()
        self.configureDefaultBottomSheet()
        self.bindOuputs()
    }

    private func configureUI() {
        self.view.backgroundColor = .grey85
        self.navigationController?.navigationBar.isHidden = true
        self.sheetPresentationController?.detents = [.custom(resolver: { _ in
            return 647
        })]

        self.view.addSubviews([self.titleView, self.collectionView])
        self.titleView.addSubview(titleLabel)

        self.configureCollectionView()
    }

    private func configureCollectionView() {
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }

    private func configureConstraints() {
        self.titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(80)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleView.snp.left).offset(24)
            make.bottom.equalTo(self.titleView.snp.bottom).offset(-12)
        }

        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.titleView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func configureDefaultBottomSheet() {
        if let sheet = sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
    }

    private func bindOuputs() {
        Observable.of(BankEntity.all)
            .asObservable()
            .bind(to: self.collectionView.rx
                .items(cellIdentifier: TicketRefundBankCollectionViewCell.className, cellType: TicketRefundBankCollectionViewCell.self)
            ) { index, entity, cell in
                cell.setData(with: entity)
            }
            .disposed(by: self.disposeBag)
    }
}

extension TicketRefundBankSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let collectionViewWidth = self.collectionView.frame.width

        let cellWidth = (collectionViewWidth - 20) / 3
        let cellHeight = cellWidth * 0.69

        return CGSize(width: cellWidth, height: cellHeight)
    }
}
