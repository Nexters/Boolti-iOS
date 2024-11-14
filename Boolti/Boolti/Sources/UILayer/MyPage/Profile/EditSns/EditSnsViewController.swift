//
//  EditSnsViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/14/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

protocol EditSnsViewControllerDelegate: AnyObject {
    func editSnsViewController(_ viewController: UIViewController, didChangedSns entity: SnsEntity)
    func editSnsViewController(_ viewController: UIViewController, didAddedSns entity: SnsEntity)
    func editSnsDidDeleted(_ viewController: UIViewController)
}

final class EditSnsViewController: BooltiViewController {

    /// EditType
    // - add => Sns 링크 추가
    // - edit => 편집 및 삭제
    // TODO: SnsEntity Data 타입과 Domain 객체 분리하기
    enum EditType {
        case add
        case edit(SnsEntity)
    }

    private let navigationBar = BooltiNavigationBar(type: .addLink)

    private let userNameTextField = ButtonTextField(with: .delete, placeHolder: "ex) boolti_official")
    private lazy var userNameStackView = BooltiInputStackView(
        title: "Username",
        textField: userNameTextField
    )

    // TODO: BooltiButton 더 재사용성 높게 변경하기
    private let deleteSnsButton: BooltiButton = {
        let button = BooltiButton(title: "SNS 삭제")
        button.setTitleColor(.grey90, for: .normal)
        button.backgroundColor = .grey15
        button.isHidden = true

        return button
    }()


    // TODO: BooltiPopUpView도 더 재사용성 높게 변경하기 -> Init에서 설정하게!
    // 항상 PopUpView를 띄어두고 있는 것(메모리)이 아니라 present하는 방식도 고민해보기
    private let deleteSnsPopUpView = BooltiPopupView()

    private let editType: EditType

    weak var delegate: EditSnsViewControllerDelegate?

    private let disposeBag = DisposeBag()

    init(editType: EditType) {
        self.editType = editType
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureConstraints()
        self.bindUIComponents()
        self.configureToastView(isButtonExisted: false)
    }

    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.userNameStackView,
                               self.deleteSnsButton,
                               self.deleteSnsPopUpView])
        self.view.backgroundColor = .grey95

        if case .edit(let sns) = self.editType {
            self.configureEditCase(with: sns)
        }
    }

    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.userNameStackView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        self.userNameStackView.updateTitleLabelConstraints(width: 65)

        self.deleteSnsButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(42)
        }

        self.deleteSnsPopUpView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureEditCase(with sns: SnsEntity) {
        self.userNameTextField.text = sns.name
        self.deleteSnsButton.isHidden = false
        self.navigationBar.changeTitle(to: "SNS 편집")
    }

    private func bindUIComponents() {
        // 링크 네임
        let userNameTextFieldObservable = self.userNameTextField.rx.text.orEmpty

        userNameTextFieldObservable
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.userNameTextField.isButtonHidden = text.isEmpty
                owner.navigationBar.rightTextButton.isEnabled = !text.isEmpty
            }
            .disposed(by: self.disposeBag)

        self.userNameTextField.didButtonTap
            .bind(with: self) { owner, _ in
                owner.userNameTextField.text = ""
                owner.userNameTextField.isButtonHidden = true
                owner.navigationBar.rightTextButton.isEnabled = false
            }
            .disposed(by: self.disposeBag)

        self.userNameTextField.rx.controlEvent([.editingDidBegin])
            .bind(with: self) { owner, _ in
                guard let nameText = owner.userNameTextField.text else { return }
                owner.userNameTextField.isButtonHidden = nameText.isEmpty
            }
            .disposed(by: self.disposeBag)

        // textField를 선택하면 empty인 지 판단하여 button을 보여줄 지 말지 결정한다.
        self.userNameTextField.rx.controlEvent([.editingDidBegin])
            .bind(with: self) { owner, _ in
                guard let urlText = owner.userNameTextField.text else { return }
                owner.userNameTextField.isButtonHidden = urlText.isEmpty
            }
            .disposed(by: self.disposeBag)

        // 완료 버튼
        self.navigationBar.didRightTextButtonTap()
            .emit(with: self) { owner, _ in
                guard let userName = owner.userNameTextField.text else { return }
                switch owner.editType {
                case .add:
                    owner.delegate?.editSnsViewController(self, didAddedSns: SnsEntity(snsType: .instagram, name: userName))
                    owner.showToast(message: "SNS를 추가했어요")
                case .edit:
                    owner.delegate?.editSnsViewController(self, didChangedSns: SnsEntity(snsType: .instagram, name: userName))
                    owner.showToast(message: "SNS를 편집했어요")
                }
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        // 삭제 버튼
        self.deleteSnsButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.deleteSnsPopUpView.showPopup(with: .deleteSns, withCancelButton: true)
            }
            .disposed(by: self.disposeBag)
        
        // 네비게이션 바 구현
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        self.bindPopUpViewComponents()

        // 키보드
        /// 키보드가 내려갈 때는 무조건 button을 숨긴다.
        RxKeyboard.instance.isHidden
            .skip(1)
            .drive(with: self) { owner, isHidden in
                if isHidden {
                    owner.userNameTextField.isButtonHidden = true
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func bindPopUpViewComponents() {
        self.deleteSnsPopUpView.didCancelButtonTap()
            .emit(with: self) { owner, _ in
                owner.deleteSnsPopUpView.isHidden = true
            }
            .disposed(by: self.disposeBag)

        self.deleteSnsPopUpView.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.deleteSnsPopUpView.isHidden = true
            }
            .disposed(by: self.disposeBag)

        self.deleteSnsPopUpView.didConfirmButtonTap()
            .emit(with: self) { owner, _ in
                owner.delegate?.editSnsDidDeleted(self)
                owner.deleteSnsPopUpView.isHidden = true
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }

}
