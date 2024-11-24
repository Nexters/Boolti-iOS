import UIKit

import RxSwift
import RxCocoa
import RxKeyboard

protocol EditLinkViewControllerDelegate: AnyObject {
    func editLinkViewController(_ viewController: UIViewController, didChangedLink entity: LinkEntity)
    func editLinkViewController(_ viewController: UIViewController, didAddedLink entity: LinkEntity)
    func editLinkDidDeleted(_ viewController: UIViewController)
}

final class EditLinkViewController: BooltiViewController {

    /// EditType
    // - add => 소셜 링크 추가
    // - edit => 편집 및 삭제
    // TODO: LinkEntity Data 타입과 Domain 객체 분리하기
    enum EditType {
        case add
        case edit(LinkEntity)
    }

    private let navigationBar = BooltiNavigationBar(type: .addLink)

    private let linkNameTextField = ButtonTextField(with: .delete, placeHolder: "링크 이름을 입력해 주세요")
    private lazy var linkNameStackView = BooltiInputStackView(
        title: "링크 이름",
        textField: linkNameTextField
    )

    private let URLTextField = ButtonTextField(with: .delete, placeHolder: "URL을 첨부해 주세요")
    private lazy var URLStackView = BooltiInputStackView(
        title: "URL",
        textField: URLTextField
    )

    // TODO: BooltiButton 더 재사용성 높게 변경하기
    private let deleteLinkButton: BooltiButton = {
        let button = BooltiButton(title: "링크 삭제")
        button.setTitleColor(.grey90, for: .normal)
        button.backgroundColor = .grey15
        button.isHidden = true

        return button
    }()


    // TODO: BooltiPopUpView도 더 재사용성 높게 변경하기 -> Init에서 설정하게!
    // 항상 PopUpView를 띄어두고 있는 것(메모리)이 아니라 present하는 방식도 고민해보기
    private let deleteLinkPopUpView = BooltiPopupView()

    private let editType: EditType

    weak var delegate: EditLinkViewControllerDelegate?

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
        self.view.addSubviews([navigationBar, linkNameStackView, URLStackView, deleteLinkButton, deleteLinkPopUpView])
        self.view.backgroundColor = .grey95

        if case .edit(let link) = self.editType {
            self.configureEditCase(with: link)
        }
    }

    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.linkNameStackView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.URLStackView.snp.makeConstraints { make in
            make.top.equalTo(self.linkNameStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.linkNameStackView)
        }

        self.deleteLinkButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(42)
        }

        self.deleteLinkPopUpView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureEditCase(with link: LinkEntity) {
        self.linkNameTextField.text = link.title
        self.URLTextField.text = link.link
        self.deleteLinkButton.isHidden = false
        self.navigationBar.changeTitle(to: "링크 편집")
    }

    private func bindUIComponents() {
        // 링크 네임
        let linkNameTextFieldObservable = self.linkNameTextField.rx.text.orEmpty

        linkNameTextFieldObservable
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.linkNameTextField.isButtonHidden = text.isEmpty
            }
            .disposed(by: self.disposeBag)

        self.linkNameTextField.didButtonTap
            .bind(with: self) { owner, _ in
                owner.linkNameTextField.text = ""
                owner.linkNameTextField.isButtonHidden = true
                owner.navigationBar.rightTextButton.isEnabled = false
            }
            .disposed(by: self.disposeBag)

        self.linkNameTextField.rx.controlEvent([.editingDidBegin])
            .bind(with: self) { owner, _ in
                guard let nameText = owner.linkNameTextField.text else { return }
                owner.linkNameTextField.isButtonHidden = nameText.isEmpty
            }
            .disposed(by: self.disposeBag)

        // URL 설정
        let URLTextFieldObservable = self.URLTextField.rx.text.orEmpty

        URLTextFieldObservable
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.URLTextField.isButtonHidden = text.isEmpty
            }
            .disposed(by: self.disposeBag)

        self.URLTextField.didButtonTap
            .bind(with: self) { owner, _ in
                owner.URLTextField.text = ""
                owner.URLTextField.isButtonHidden = true
                owner.navigationBar.rightTextButton.isEnabled = false
            }
            .disposed(by: self.disposeBag)

        // textField를 선택하면 empty인 지 판단하여 button을 보여줄 지 말지 결정한다.
        self.URLTextField.rx.controlEvent([.editingDidBegin])
            .bind(with: self) { owner, _ in
                guard let urlText = owner.URLTextField.text else { return }
                owner.URLTextField.isButtonHidden = urlText.isEmpty
            }
            .disposed(by: self.disposeBag)

        Observable.combineLatest(
            linkNameTextFieldObservable.distinctUntilChanged(),
            URLTextFieldObservable.distinctUntilChanged()
        )
        .map { urlText, linkNameText in
            return !urlText.isEmpty && !linkNameText.isEmpty
        }
        .bind(to: self.navigationBar.rightTextButton.rx.isEnabled)
        .disposed(by: self.disposeBag)

        // 완료 버튼
        self.navigationBar.didRightTextButtonTap()
            .emit(with: self) { owner, _ in
                guard let title = owner.linkNameTextField.text else { return }
                guard let link = owner.URLTextField.text else { return }
                switch owner.editType {
                case .add:
                    owner.delegate?.editLinkViewController(self, didAddedLink: LinkEntity(title: title, link: link))
                    owner.showToast(message: "링크를 추가했어요")
                case .edit:
                    owner.delegate?.editLinkViewController(self, didChangedLink: LinkEntity(title: title, link: link))
                    owner.showToast(message: "링크를 편집했어요")
                }
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)

        // 삭제 버튼
        self.deleteLinkButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.deleteLinkPopUpView.showPopup(with: .deleteLink, withCancelButton: true)
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
                    owner.linkNameTextField.isButtonHidden = true
                    owner.URLTextField.isButtonHidden = true
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func bindPopUpViewComponents() {
        self.deleteLinkPopUpView.didCancelButtonTap()
            .emit(with: self) { owner, _ in
                owner.deleteLinkPopUpView.isHidden = true
            }
            .disposed(by: self.disposeBag)

        self.deleteLinkPopUpView.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.deleteLinkPopUpView.isHidden = true
            }
            .disposed(by: self.disposeBag)

        self.deleteLinkPopUpView.didConfirmButtonTap()
            .emit(with: self) { owner, _ in
                owner.delegate?.editLinkDidDeleted(self)
                owner.deleteLinkPopUpView.isHidden = true
                owner.showToast(message: "링크를 삭제했어요")
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}
