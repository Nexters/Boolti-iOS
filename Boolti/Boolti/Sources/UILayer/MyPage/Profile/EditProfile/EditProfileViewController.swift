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
                                       self.editSnsView,
                                       self.editLinkView])
        stackView.setCustomSpacing(0, after: self.editProfileImageView)
        
        return stackView
    }()
    
    private let editProfileImageView = EditProfileImageView()
    
    private let editNicknameView = EditNicknameView()
    
    private let editIntroductionView = EditIntroductionView()
    
    private let editSnsView = EditSnsView()
    
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
        self.editSnsView.snsCollectionView.reloadData()
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
                owner.navigationBar.rightTextButton.isEnabled = !text.isEmpty
                owner.viewModel.input.didNickNameTyped.accept(text)
            }
            .disposed(by: self.disposeBag)

        self.editIntroductionView.introductionTextView.rx.text
            .orEmpty
            .asDriver()
            .drive(with: self, onNext: { owner, text in
                owner.navigationBar.rightTextButton.isEnabled = !text.isEmpty
                if !owner.editIntroductionView.isShowingPlaceHolder {
                    owner.viewModel.input.didIntroductionTyped.accept(text)
                }
            })
            .disposed(by: self.disposeBag)

        self.navigationBar.didBackButtonTap()
            .emit(to: self.viewModel.input.didBackButtonTapped)
            .disposed(by: self.disposeBag)
        
        self.navigationBar.didRightTextButtonTap()
            .emit(with: self, onNext: { owner, _ in
                owner.viewModel.input.didNavigationBarCompleteButtonTapped.onNext(())
            })
            .disposed(by: self.disposeBag)

        self.popupView.didConfirmButtonTap()
            .emit(with: self, onNext: { owner, _ in
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
        self.editSnsView.snsCollectionView.dataSource = self
        self.editSnsView.snsCollectionView.delegate = self
        self.editSnsView.snsCollectionView.dragDelegate = self
        self.editSnsView.snsCollectionView.dropDelegate = self
        
        self.editSnsView.snsCollectionView.register(AddLinkHeaderView.self,
                                                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                      withReuseIdentifier: AddLinkHeaderView.className)
        
        self.editSnsView.snsCollectionView.register(EditSnsCollectionViewCell.self,
                                                      forCellWithReuseIdentifier: EditSnsCollectionViewCell.className)

        self.editLinkView.linkCollectionView.dataSource = self
        self.editLinkView.linkCollectionView.delegate = self
        self.editLinkView.linkCollectionView.dragDelegate = self
        self.editLinkView.linkCollectionView.dropDelegate = self
        
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
        self.editSnsView.snsCollectionView.layoutIfNeeded()
        let snsCollectionViewHeight = self.editSnsView.snsCollectionView.contentSize.height
        self.editSnsView.snsCollectionView.snp.updateConstraints { make in
            make.height.equalTo(snsCollectionViewHeight)
        }

        self.editLinkView.linkCollectionView.layoutIfNeeded()
        let linkCollectionViewHeight = self.editLinkView.linkCollectionView.contentSize.height
        self.editLinkView.linkCollectionView.snp.updateConstraints { make in
            make.height.equalTo(linkCollectionViewHeight)
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
        if collectionView == self.editSnsView.snsCollectionView {
            guard let snses = self.viewModel.output.profile.snses else { return 0 }
            return snses.count
        } else {
            guard let links = self.viewModel.output.profile.links else { return 0 }
            return links.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: AddLinkHeaderView.className,
                for: indexPath
              ) as? AddLinkHeaderView else { return UICollectionReusableView() }
        
        // 기존 disposeBag이 있다면 초기화
        header.disposeBag = DisposeBag()
        
        if collectionView == self.editSnsView.snsCollectionView {
            header.setTitle(with: "SNS 추가")
            
            header.rx.tapGesture()
                .when(.recognized)
                .bind(with: self) { owner, _ in
                    let viewController = EditSnsViewController(editType: .add)
                    viewController.delegate = self
                    owner.navigationController?.pushViewController(viewController, animated: true)
                }
                .disposed(by: header.disposeBag)
        } else {
            header.setTitle(with: "링크 추가")
            
            header.rx.tapGesture()
                .when(.recognized)
                .bind(with: self) { owner, _ in
                    let viewController = EditLinkViewController(editType: .add)
                    viewController.delegate = self
                    owner.navigationController?.pushViewController(viewController, animated: true)
                }
                .disposed(by: header.disposeBag)
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.editSnsView.snsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditSnsCollectionViewCell.className,
                                                                for: indexPath) as? EditSnsCollectionViewCell else { return UICollectionViewCell() }
            guard let snses = self.viewModel.output.profile.snses else { return UICollectionViewCell() }

            cell.setData(with: snses[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditLinkCollectionViewCell.className,
                                                                for: indexPath) as? EditLinkCollectionViewCell else { return UICollectionViewCell() }
            guard let links = self.viewModel.output.profile.links else { return UICollectionViewCell() }

            cell.setData(with: links[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.editSnsView.snsCollectionView {
            guard let snses = self.viewModel.output.profile.snses else { return }

            let snsEntity = snses[indexPath.row]
            self.selectedItemIndex = indexPath.row

            let viewController = EditSnsViewController(editType: .edit(snsEntity))
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            guard let links = self.viewModel.output.profile.links else { return }

            let linkEntity = links[indexPath.row]
            self.selectedItemIndex = indexPath.row

            let viewController = EditLinkViewController(editType: .edit(linkEntity))
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension EditProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.editSnsView.snsCollectionView {
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 44)
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 56)
        }
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

// MARK: - UICollectionViewDragDelegate

extension EditProfileViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard collectionView.hasActiveDrag else { return UICollectionViewDropProposal(operation: .forbidden) }
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

}

// MARK: - UICollectionViewDropDelegate

extension EditProfileViewController: UICollectionViewDropDelegate {
    
   func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
       var destinationIndexPath: IndexPath
       if let indexPath = coordinator.destinationIndexPath {
           destinationIndexPath = indexPath
       } else {
           let item = collectionView.numberOfItems(inSection: 0)
           destinationIndexPath = IndexPath(item: item - 1, section: 0)
       }

       guard let item = coordinator.items.first,
             let sourceIndexPath = item.sourceIndexPath else { return }
       
       if collectionView == self.editSnsView.snsCollectionView {
           guard var snses = self.viewModel.output.profile.snses else { return }
           collectionView.performBatchUpdates {
               let sourceItem = snses.remove(at: sourceIndexPath.item)
               snses.insert(sourceItem, at: destinationIndexPath.item)
               collectionView.deleteItems(at: [sourceIndexPath])
               collectionView.insertItems(at: [destinationIndexPath])
               coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
               print(snses)
               self.viewModel.input.didSnsChanged.accept(snses)
               self.reloadLinks()
           }
       } else {
           guard var links = self.viewModel.output.profile.links else { return }
           collectionView.performBatchUpdates {
               let sourceItem = links.remove(at: sourceIndexPath.item)
               links.insert(sourceItem, at: destinationIndexPath.item)
               collectionView.deleteItems(at: [sourceIndexPath])
               collectionView.insertItems(at: [destinationIndexPath])
               coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
               print(links)
               self.viewModel.input.didLinkChanged.accept(links)
               self.reloadLinks()
           }
       }
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
        
        self.editSnsView.snsCollectionView.snp.makeConstraints { make in
            make.height.equalTo(0)
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
        links.append(entity)
        
        self.viewModel.input.didLinkChanged.accept(links)
        self.reloadLinks()
    }

}

// MARK: EditSnsViewControllerDelegate

extension EditProfileViewController: EditSnsViewControllerDelegate {
    
    func editSnsDidDeleted(_ viewController: UIViewController) {
        guard var snses = self.viewModel.output.profile.snses else { return }
        snses.remove(at: self.selectedItemIndex)
        
        self.viewModel.input.didSnsChanged.accept(snses)
        self.reloadLinks()
    }
    
    func editSnsViewController(_ viewController: UIViewController, didChangedSns entity: SnsEntity) {
        guard var snses = self.viewModel.output.profile.snses else { return }
        snses[self.selectedItemIndex] = entity
        
        self.viewModel.input.didSnsChanged.accept(snses)
        self.reloadLinks()
    }
    
    func editSnsViewController(_ viewController: UIViewController, didAddedSns entity: SnsEntity) {
        guard var snses = self.viewModel.output.profile.snses else { return }
        snses.append(entity)
        
        self.viewModel.input.didSnsChanged.accept(snses)
        self.reloadLinks()
    }

}
