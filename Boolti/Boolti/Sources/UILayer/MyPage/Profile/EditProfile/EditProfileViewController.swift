//
//  EditProfileViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/4/24.
//

import UIKit

import RxSwift
import RxCocoa

final class EditProfileViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: EditProfileViewModel
    
    // MARK: UI Components
    
    private let navigationBar = BooltiNavigationBar(type: .editProfile)
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubviews([self.stackView])
        
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.addArrangedSubviews([self.editProfileImageView,
                                       self.editNicknameView])
        stackView.setCustomSpacing(0, after: self.editProfileImageView)

        return stackView
    }()
    
    private let editProfileImageView = EditProfileImageView()
    
    private let editNicknameView = EditNicknameView()
    
    // MARK: Initailizer
    
    init(viewModel: EditProfileViewModel) {
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
        self.bindUIComponents()
    }
    
}

// MARK: - Methods

extension EditProfileViewController {
    
    private func bindUIComponents() {
        self.editProfileImageView.profileImageView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                print("image view tap")
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UI

extension EditProfileViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.view.addSubviews([self.navigationBar,
                               self.mainScrollView])
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.mainScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.mainScrollView)
            make.width.equalTo(self.mainScrollView)
        }
    }
    
}
