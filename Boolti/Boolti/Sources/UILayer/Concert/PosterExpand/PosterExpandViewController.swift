//
//  PosterExpandViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/24/24.
//

import UIKit

import RxSwift

final class PosterExpandViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: PosterExpandViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)
        return button
    }()
    
    private lazy var posterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.className)
        return collectionView
    }()
    
    private let pageControl = UIPageControl()
    
    // MARK: Init
    
    init(viewModel: PosterExpandViewModel) {
        self.viewModel = viewModel
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
        self.bindUIComponents()
    }
}

// MARK: - UICollectionViewDataSource

extension PosterExpandViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.className, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(with: viewModel.posters[indexPath.item].path)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PosterExpandViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Methods

extension PosterExpandViewController {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.posterCollectionView {
            self.pageControl.currentPage = Int(round(scrollView.contentOffset.x / self.view.frame.width))
        }
    }

    private func bindUIComponents() {
        closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UI

extension PosterExpandViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.closeButton,
                               self.posterCollectionView,
                               self.pageControl])
        self.view.backgroundColor = .grey95
        self.pageControl.numberOfPages = self.viewModel.posters.count
    }
    
    private func configureConstraints() {
        self.closeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        self.posterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(44)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(47)
        }
        
        self.pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
