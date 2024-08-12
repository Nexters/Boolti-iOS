//
//  ResignReasonViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/22/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ResignReasonViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: ResignReasonViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "계정 삭제"))
    
    private let mainTitle: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .point4
        label.textColor = .grey05
        label.text = "삭제 이유를 입력해 주세요"
        return label
    }()
    
    private let reasonTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = .init(top: 13, left: 12, bottom: 13, right: 12)
        textView.backgroundColor = .grey85
        textView.layer.cornerRadius = 4
        textView.font = .body3
        textView.text = "예) 계정 삭제 후 재 가입할게요"
        textView.textColor = .grey70
        return textView
    }()
    
    private let resignButton = BooltiButton(title: "삭제하기")
    
    // MARK: Init
    
    init(viewModel: ResignReasonViewModel) {
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
        self.configureConstraints()
        self.configureToastView(isButtonExisted: true)
        self.bindUIComponents()
    }
}

// MARK: - Methods

extension ResignReasonViewController {

    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.resignButton.rx.tap
            .do(onNext: { self.viewModel.input.reason.accept(self.reasonTextView.text) })
            .bind(to: self.viewModel.input.didResignConfirmButtonTap)
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.didResignAccount
            .subscribe(with: self) { owner, _ in
                owner.showToast(message: "계정 삭제가 완료되었어요")
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.reasonTextView.rx.didBeginEditing
            .bind(with: self) { owner, _ in
                if owner.reasonTextView.textColor == .grey70 {
                    owner.reasonTextView.text = nil
                    owner.reasonTextView.textColor = .grey10
                }
            }
            .disposed(by: self.disposeBag)
        
        self.reasonTextView.rx.didEndEditing
            .bind(with: self) { owner, _ in
                guard let changedText = owner.reasonTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                
                if changedText.isEmpty {
                    owner.reasonTextView.textColor = .grey70
                    owner.reasonTextView.text = "예) 계정 삭제 후 재 가입할게요"
                    owner.resignButton.isEnabled = false
                } else {
                    owner.viewModel.input.reason.accept(changedText)
                    owner.resignButton.isEnabled = true
                }
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension ResignReasonViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.mainTitle,
                               self.reasonTextView,
                               self.resignButton])
        
        self.view.backgroundColor = .grey95
        self.resignButton.isEnabled = false
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.mainTitle.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.reasonTextView.snp.makeConstraints { make in
            make.top.equalTo(self.mainTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self.mainTitle)
            make.height.equalTo(160)
        }
        
        self.resignButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
        }
    }
}
