//
//  LinkListViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class LinkListViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private var viewModel: LinkListViewModel
    
    // MARK: UI Components
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "링크"))
    
    private let linkCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        return collectionView
    }()
    
    // MARK: Initailizer
    
    init(viewModel: LinkListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureToastView(isButtonExisted: false)
        self.configureCollectionView()
        self.bindUIComponents()
    }
    
}

// MARK: - Methods

extension LinkListViewController {
    
    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.linkCollectionView.rx.itemSelected
            .map { $0.row }
            .subscribe(with: self) { owner, index in
                guard let url = URL(string: owner.viewModel.linkList[index].link) else { return }
                if UIApplication.shared.canOpenURL(url) {
                    owner.openSafari(with: url)
                } else {
                    owner.showToast(message: "유효한 링크가 아니에요")
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureCollectionView() {
        self.linkCollectionView.delegate = self
        self.linkCollectionView.dataSource = self
        
        self.linkCollectionView.register(ProfileLinkCollectionViewCell.self, forCellWithReuseIdentifier: ProfileLinkCollectionViewCell.className)
    }
    
}

// MARK: - UICollectionViewDataSource

extension LinkListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.linkList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileLinkCollectionViewCell.className,
                                                            for: indexPath) as? ProfileLinkCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(linkName: self.viewModel.linkList[indexPath.row].title)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LinkListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.linkCollectionView.frame.width - 40, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

}


// MARK: - UI

extension LinkListViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.view.addSubviews([self.navigationBar,
                               self.linkCollectionView])

        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.linkCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
