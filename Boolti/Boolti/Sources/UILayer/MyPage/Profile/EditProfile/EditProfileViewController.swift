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

    private var selectedItemIndex = 0

    // MARK: UI Components
    
    private let navigationBar = BooltiNavigationBar(type: .editProfile)
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 12, right: 0)
        scrollView.keyboardDismissMode = .onDrag
        scrollView.addSubview(self.stackView)
        scrollView.delegate = self
        scrollView.isHidden = true
        
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
    
    private let popupView = BooltiPopupView()
    
    private let imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        return imagePickerController
    }()
    
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
        self.bindViewModel()
        self.configureGesture()
        self.configureKeyboardNotification()
        self.configureToastView(isButtonExisted: false)
        self.configureLinkCollectionView()
        self.configureImagePickerController()
        self.viewModel.fetchProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}

// MARK: - Methods

extension EditProfileViewController {
    
    private func reloadLinks() {
        self.editLinkView.linkCollectionView.reloadData()
        self.updateCollectionViewHeight()
    }
    
    private func bindViewModel() {
        self.viewModel.output.fetchedProfile
            .subscribe(with: self) { owner, profile in
                owner.editProfileImageView.setImage(imageURL: profile?.imageURL ?? "")
                owner.editNicknameView.setData(with: profile?.nickName ?? "")
                owner.editIntroductionView.setData(with: profile?.introduction ?? "")
                // TODO: 추후에 RxCocoa Datasource로 끌고 가는게 더 좋을듯
                /// 그래서 links를 그냥 input으로 넣어줘서 바로 해당 array로 collection view를 만들 수 있도록..
                owner.reloadLinks()
                
                owner.mainScrollView.isHidden = false
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.didProfileSaved
            .subscribe(with: self) { owner, _ in
                owner.showToast(message: "프로필 편집을 완료했어요")
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.isProfileChanged
            .subscribe(with: self) { owner, isChanged in
                if isChanged {
                    owner.popupView.showPopup(with: .saveProfile, withCancelButton: true)
                } else {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindUIComponents() {
        self.editProfileImageView.profileImageView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.present(owner.imagePickerController, animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.editNicknameView.nicknameTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(with: self) { owner, text in
                owner.navigationBar.completeButton.isEnabled = !text.isEmpty
                owner.viewModel.input.didNickNameTyped.accept(text)
            }
            .disposed(by: self.disposeBag)

        self.editIntroductionView.introductionTextView.rx.text
            .orEmpty
            .asDriver()
            .drive(with: self, onNext: { owner, text in
                owner.navigationBar.completeButton.isEnabled = !text.isEmpty
                if !owner.editIntroductionView.isShowingPlaceHolder {
                    owner.viewModel.input.didIntroductionTyped.accept(text)
                }
            })
            .disposed(by: self.disposeBag)

        self.navigationBar.didBackButtonTap()
            .emit(to: self.viewModel.input.didBackButtonTapped)
            .disposed(by: self.disposeBag)
        
        self.navigationBar.didCompleteButtonTap()
            .emit(with: self, onNext: { owner, _ in
                // TODO: 아래와 같이 url이랑 image 따로 보내는 거 해결하기 (vm 참고)
                let image = owner.editProfileImageView.profileImageView.image ?? UIImage()
                owner.viewModel.input.didProfileImageSelected.accept(image)
                owner.viewModel.input.didNavigationBarCompleteButtonTapped.onNext(())
            })
            .disposed(by: self.disposeBag)

        self.popupView.didConfirmButtonTap()
            .emit(with: self, onNext: { owner, _ in
                let image = owner.editProfileImageView.profileImageView.image ?? UIImage()
                owner.viewModel.input.didProfileImageSelected.accept(image)
                owner.viewModel.input.didPopUpConfirmButtonTapped.onNext(())
            })
            .disposed(by: self.disposeBag)

        self.popupView.didCancelButtonTap()
            .emit(with: self) { owner, _ in
                owner.popupView.isHidden = true
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.popupView.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.popupView.isHidden = true
            }
            .disposed(by: self.disposeBag)
    }

    private func configureLinkCollectionView() {
        self.editLinkView.linkCollectionView.dataSource = self
        self.editLinkView.linkCollectionView.delegate = self
        
        self.editLinkView.linkCollectionView.register(AddLinkHeaderView.self,
                                                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                      withReuseIdentifier: AddLinkHeaderView.className)
        self.editLinkView.linkCollectionView.register(EditLinkCollectionViewCell.self,
                                                      forCellWithReuseIdentifier: EditLinkCollectionViewCell.className)
    }
    
    private func configureImagePickerController() {
        self.imagePickerController.delegate = self
    }
    
    private func updateCollectionViewHeight() {
        self.editLinkView.linkCollectionView.layoutIfNeeded()
        let height = self.editLinkView.linkCollectionView.contentSize.height
        self.editLinkView.linkCollectionView.snp.updateConstraints { make in
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

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true) {
            self.editProfileImageView.profileImageView.image = selectedImage
            self.viewModel.input.didProfileImageSelected.accept(selectedImage)
        }
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
        guard let links = self.viewModel.output.profile.links else { return 0 }
        return links.count
    }
    
    /// 헤더를 결정하는 메서드
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: AddLinkHeaderView.className,
                for: indexPath
              ) as? AddLinkHeaderView else { return UICollectionReusableView() }
        
        header.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                let viewController = EditLinkViewController(editType: .add)
                viewController.delegate = self
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: header.disposeBag)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditLinkCollectionViewCell.className,
                                                            for: indexPath) as? EditLinkCollectionViewCell else { return UICollectionViewCell() }
        guard let links = self.viewModel.output.profile.links else { return UICollectionViewCell() }

        let data = links[indexPath.row]

        cell.setData(title: data.title, url: data.link)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let links = self.viewModel.output.profile.links else { return }

        let linkEntity = links[indexPath.row]
        self.selectedItemIndex = indexPath.row

        let viewController = EditLinkViewController(editType: .edit(linkEntity))
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: AddLinkHeaderView.className,
            for: indexPath
        ) as? AddLinkHeaderView else { return }
        
        header.disposeBag = DisposeBag()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 40, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 56)
    }
}

// MARK: - UI

extension EditProfileViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.view.addSubviews([self.navigationBar,
                               self.mainScrollView,
                               self.popupView])
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
        
        self.popupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.editLinkView.linkCollectionView.snp.makeConstraints { make in
            make.height.equalTo(0)
        }
    }
}

// MARK: EditLinkViewControllerDelegate

extension EditProfileViewController: EditLinkViewControllerDelegate {
    func editLinkDidDeleted(_ viewController: UIViewController) {
        guard var links = self.viewModel.output.profile.links else { return }
        links.remove(at: self.selectedItemIndex)

        self.viewModel.input.didLinkChanged.accept(links)
        self.reloadLinks()
    }
    
    func editLinkViewController(_ viewController: UIViewController, didChangedLink entity: LinkEntity) {
        guard var links = self.viewModel.output.profile.links else { return }
        links[self.selectedItemIndex] = entity

        self.viewModel.input.didLinkChanged.accept(links)
        self.reloadLinks()
    }
    
    func editLinkViewController(_ viewController: UIViewController, didAddedLink entity: LinkEntity) {
        guard var links = self.viewModel.output.profile.links else { return }
        links.insert(entity, at: 0)

        self.viewModel.input.didLinkChanged.accept(links)
        self.reloadLinks()
    }
}
