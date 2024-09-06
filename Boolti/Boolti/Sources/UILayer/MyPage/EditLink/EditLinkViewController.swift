//
//  EditLinkViewController.swift
//  Boolti
//
//  Created by Miro on 9/5/24.
//

import UIKit

import RxSwift
import RxCocoa

struct SocialLink {
    let linkName: String
    let URLLink: String
}

final class EditLinkViewController: BooltiViewController {

    /// EditType
    // - add => 소셜 링크 추가
    // - edit => 편집 및 삭제
    enum EditType {
        case add
        case edit(SocialLink)
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

    private func configureEditCase(with socialLink: SocialLink) {
        self.linkNameTextField.text = socialLink.linkName
        self.URLTextField.text = socialLink.URLLink
        self.deleteLinkButton.isHidden = false
    }

    private func bindUIComponents() {
        // 링크 네임
        self.linkNameTextField.rx.text.orEmpty
            .skip(1)
            .bind(with: self) { owner, text in
                owner.linkNameTextField.isButtonHidden = text.isEmpty
            }
            .disposed(by: self.disposeBag)

        self.linkNameTextField.didButtonTap
            .bind(with: self) { owner, _ in
                owner.linkNameTextField.text = ""
                owner.linkNameTextField.isButtonHidden = true
            }
            .disposed(by: self.disposeBag)

        // URL 설정
        self.URLTextField.rx.text.orEmpty
            .skip(1)
            .bind(with: self) { owner, text in
                owner.URLTextField.isButtonHidden = text.isEmpty
            }
            .disposed(by: self.disposeBag)

        self.URLTextField.didButtonTap
            .bind(with: self) { owner, _ in
                owner.URLTextField.text = ""
                owner.URLTextField.isButtonHidden = true
            }
            .disposed(by: self.disposeBag)

        // 완료 버튼
        self.navigationBar.didCompleteButtonTap()
            .emit(with: self) { owner, _ in
                // 완료 API 쏘기
                print("완료되었습니다.")
            }
            .disposed(by: self.disposeBag)

        // 삭제 버튼
        self.deleteLinkButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.deleteLinkPopUpView.showPopup(with: .deleteLink, withCancelButton: true)
            }
            .disposed(by: self.disposeBag)

        self.bindPopUpViewComponents()
    }

    private func bindPopUpViewComponents() {
        self.deleteLinkPopUpView.didCancelButtonTap()
            .emit(with: self) { owner, _ in
                owner.deleteLinkPopUpView.isHidden = true
            }
            .disposed(by: self.disposeBag)

        self.deleteLinkPopUpView.didConfirmButtonTap()
            .emit(with: self) { owner, _ in
                // Delegate 메소드 요청
//                owner.deleteLinkPopUpView.isHidden = true
            }
            .disposed(by: self.disposeBag)

        self.deleteLinkPopUpView.didCloseButtonTap()
            .emit(with: self) { owner, _ in
                owner.deleteLinkPopUpView.isHidden = true
            }
            .disposed(by: self.disposeBag)
    }
}
