//
//  ProfileViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ProfileViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: ProfileViewModel
    
    // MARK: UI Components
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "프로필"))
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addSubviews([self.stackView])
        
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubviews([self.profileMainView])
        
        return stackView
    }()
    
    private let profileMainView = ProfileMainView()

    // MARK: Initailizer
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.bindUIComponents()
    }
    
}

// MARK: - Methods

extension ProfileViewController {
    
    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.profileMainView.didEditButtonTap()
            .emit(with: self) { owner, _ in
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UIScrollViewDelegate

extension ProfileViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset <= self.profileMainView.frame.height {
            self.navigationBar.setBackgroundColor(with: .grey90)
        } else {
            self.navigationBar.setBackgroundColor(with: .grey95)
        }
    }

}

// MARK: - UI

extension ProfileViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.scrollView])
        self.navigationBar.setBackgroundColor(with: .grey90)
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        self.stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalTo(self.scrollView)
        }
    }
    
}
