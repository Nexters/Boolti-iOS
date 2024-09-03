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

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .grey95
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16

        return stackView
    }()

    private let profileMainView = ProfileMainView()

    private let SNSLinksHeaderLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "SNS 링크"
        return label
    }()

    private let dataCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.contentInset = .init(top: 0, left: 20, bottom: 32, right: 20)
        return collectionView
    }()
    
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
        self.viewModel.fetchLinkList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.bindUIComponents()
        self.bindViewModel()
    }
}

// MARK: - Methods

extension ProfileViewController {

    private func bindViewModel() {
        self.viewModel.output.didProfileFetch
            .subscribe(with: self) { owner, introduction in
                owner.profileMainView.setData(introduction: introduction)
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.links
            .subscribe(with: self) { owner, links in
                guard let links else { return self.SNSLinksHeaderLabel.isHidden = true }
                owner.configureSNSStackView(with: links)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.profileMainView.didEditButtonTap()
            .emit(with: self) { owner, _ in
                print("edit button tap!")
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension ProfileViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.navigationBar.setBackgroundColor(with: .grey90)

        self.view.addSubviews([self.navigationBar, self.scrollView])
        self.scrollView.addSubview(self.contentStackView)

        self.contentStackView.addArrangedSubviews([
            self.profileMainView,
            self.SNSLinksHeaderLabel,
        ])

        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.contentStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalTo(self.view.snp.horizontalEdges)
        }

        self.profileMainView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }

        self.SNSLinksHeaderLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.snp.horizontalEdges).inset(20)
        }

        self.contentStackView.setCustomSpacing(32, after: self.profileMainView)
    }

    private func configureSNSStackView(with linkEntites: [LinkEntity]) {
        let views = linkEntites.map { ProfileLinkView(with: $0) }
        self.contentStackView.addArrangedSubviews(views)
        
        views.forEach {
            $0.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(self.view.snp.horizontalEdges).inset(20)
                make.height.equalTo(56)
            }
        }
    }
}
