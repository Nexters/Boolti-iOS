//
//  QRExpandViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import UIKit

import RxSwift
import RxCocoa

final class QRExpandViewController: BooltiViewController {

    // MARK: Properties

    private let viewModel: QRExpandViewModel
    private let disposeBag = DisposeBag()

    // MARK: UI Component

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey90
        return button
    }()

    private lazy var QRCodeExpandCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0 // 기본적으로 10으로 설정되어있다. 따라서 0으로 설정해줘야된다.

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(
            TicketCollectionViewCell.self,
            forCellWithReuseIdentifier: TicketCollectionViewCell.className
        )
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    private let QRCodeExpandPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black

        return pageControl
    }()

    // MARK: Init

    init(viewModel: QRExpandViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        self.configureConstraints()
        self.bindUIComponents()
        self.bindOutput()
    }
}

// MARK: - Methods

extension QRExpandViewController {

    private func bindUIComponents() {

        self.QRCodeExpandCollectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)

        self.closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.QRCodeExpandCollectionView.rx.didScroll
            .subscribe(with: self) { owner, _ in
                let offSet = owner.QRCodeExpandCollectionView.contentOffset.x
                let width = owner.QRCodeExpandCollectionView.frame.width
                let horizontalCenter = width / 2

                owner.QRCodeExpandPageControl.rx.currentPage.onNext(Int(offSet + horizontalCenter) / Int(width))
            }
            .disposed(by: self.disposeBag)

        self.QRCodeExpandCollectionView.rx.willDisplayCell
            .take(1)
            .subscribe(with: self) { owner, argument in
                owner.QRCodeExpandCollectionView.scrollToItem(
                    at: self.viewModel.output.indexPath,
                    at: .centeredHorizontally,
                    animated: false
                )
            }
            .disposed(by: self.disposeBag)
    }

private func bindOutput() {
    // 굳이 Rx로 할 필요는 없지만, delegate 메소드 하나라도 없앨 수 있으므로 Rx사용
    Observable.of(self.viewModel.output.tickets)
        .do(onNext: { [weak self] tickets in
            self?.QRCodeExpandPageControl.rx.numberOfPages.onNext(tickets.count)
        })
        .bind(to: self.QRCodeExpandCollectionView.rx.items(
            cellIdentifier: TicketCollectionViewCell.className,
            cellType: TicketCollectionViewCell.self)
        ) { index, entity, cell in
            cell.setData(with: entity)
            cell.updateConstraintsForExpand()
        }
        .disposed(by: self.disposeBag)
}
}

// MARK: - UI

extension QRExpandViewController {

    private func configureUI() {
        self.view.addSubviews([
            self.closeButton,
            self.QRCodeExpandCollectionView,
            self.QRCodeExpandPageControl
        ])

        self.view.backgroundColor = .white00
    }

    private func configureConstraints() {
        self.closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }

        self.QRCodeExpandPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
        }

        self.QRCodeExpandCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.closeButton.snp.bottom)
            make.bottom.equalTo(self.QRCodeExpandPageControl.snp.top)
            make.horizontalEdges.equalToSuperview()
        }
    }
}


extension QRExpandViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
