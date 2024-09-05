//
//  AddLinkViewController.swift
//  Boolti
//
//  Created by Miro on 9/5/24.
//

import UIKit

import RxSwift
import RxCocoa

final class AddLinkViewController: BooltiViewController {

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

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureConstraints()
        self.bindUIComponents()
    }

    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.view.addSubviews([navigationBar, linkNameStackView, URLStackView])
    }

    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        self.linkNameStackView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.URLStackView.snp.makeConstraints { make in
            make.top.equalTo(self.linkNameStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.linkNameStackView)
        }
    }

    private func bindUIComponents() {
        self.linkNameTextField.rx.text.orEmpty
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEmpty in
                owner.linkNameTextField.isButtonHidden = isEmpty
            }
            .disposed(by: self.disposeBag)

        self.URLTextField.rx.text.orEmpty
            .map { $0.isEmpty }
            .distinctUntilChanged()
            .bind(with: self) { owner, isEmpty in
                owner.URLTextField.isButtonHidden = isEmpty
            }
            .disposed(by: self.disposeBag)
    }
}
