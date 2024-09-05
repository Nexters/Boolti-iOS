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
    
    private var isScrollViewOffsetChanged: Bool = false
    private var changedScrollViewOffsetY: CGFloat = 0
    
    // MARK: UI Components
    
    private let navigationBar = BooltiNavigationBar(type: .editProfile)
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 12, right: 0)
        scrollView.keyboardDismissMode = .onDrag
        scrollView.addSubview(self.stackView)
        scrollView.delegate = self
        
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.addArrangedSubviews([self.editProfileImageView,
                                       self.editNicknameView,
                                       self.editIntroductionView,
                                       self.editLinkView])
        stackView.setCustomSpacing(0, after: self.editProfileImageView)

        return stackView
    }()
    
    private let editProfileImageView = EditProfileImageView()
    
    private let editNicknameView = EditNicknameView()
    
    private let editIntroductionView = EditIntroductionView()
    
    private let editLinkView = EditLinkView()
    
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
        self.configureGesture()
        self.configureKeyboardNotification()
        self.configureToastView(isButtonExisted: false)
        self.setOriginData()
        self.configureLinkCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateCollectionViewHeight()
    }
    
}

// MARK: - Methods

extension EditProfileViewController {
    
    private func setOriginData() {
        self.editProfileImageView.setImage(imageURL: UserDefaults.userImageURLPath)
        self.editNicknameView.setData(with: UserDefaults.userName)
    }
    
    private func bindUIComponents() {
        self.editProfileImageView.profileImageView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                print("image view tap")
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureLinkCollectionView() {
        self.editLinkView.linkCollectionView.dataSource = self
        self.editLinkView.linkCollectionView.delegate = self
        
        self.editLinkView.linkCollectionView.register(EditLinkCollectionViewCell.self,
                                                      forCellWithReuseIdentifier: EditLinkCollectionViewCell.className)
    }
    
    private func updateCollectionViewHeight() {
        self.editLinkView.linkCollectionView.layoutIfNeeded()
        let height = self.editLinkView.linkCollectionView.contentSize.height
        self.editLinkView.linkCollectionView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
                  let currentTextView = UIResponder.currentResponder as? UITextView else { return }
            
            let keyboardTopY = keyboardFrame.cgRectValue.origin.y
            let convertedTextViewFrame = self.view.convert(currentTextView.frame,
                                                            from: currentTextView.superview)
            let textViewBottomY = convertedTextViewFrame.origin.y + convertedTextViewFrame.size.height
            if textViewBottomY > keyboardTopY * 0.9 {
                let changeOffset = textViewBottomY - keyboardTopY + convertedTextViewFrame.size.height
                self.mainScrollView.setContentOffset(CGPoint(x: 0, y: self.mainScrollView.contentOffset.y + changeOffset), animated: true)
                
                self.isScrollViewOffsetChanged = true
                self.changedScrollViewOffsetY = changeOffset
            }
        }
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
                if owner.isScrollViewOffsetChanged {
                    owner.mainScrollView.setContentOffset(CGPoint(x: 0, y: owner.mainScrollView.contentOffset.y - owner.changedScrollViewOffsetY), animated: true)
                    owner.isScrollViewOffsetChanged = false
                }
            })
            .disposed(by: self.disposeBag)
    }
    
}


// MARK: - UIScrollViewDelegate

extension EditProfileViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrollViewOffsetChanged = false
    }

}


// MARK: - UICollectionViewDataSource

extension EditProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    /// 헤더를 결정하는 메서드
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("호출")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditLinkCollectionViewCell.className,
                                                            for: indexPath) as? EditLinkCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(title: "YouTube", url: "www.youtube.com/watch?v=AaHV1Eea1R0")
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 40, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
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
