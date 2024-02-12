//
//  ReportViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ReportViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: ReportViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .report)
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.text = "신고 사유를 입력해주세요"
        label.font = .point4
        label.textColor = .grey05
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = "관리자 확인 후 공연이 삭제되며\n적절한 사유가 아닌 경우 반려될 수 있어요"
        label.numberOfLines = 2
        label.setLineSpacing(lineSpacing: 4)
        label.font = .body3
        label.textColor = .grey30
        return label
    }()
    
    private let reasonTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = .init(top: 13, left: 12, bottom: 13, right: 12)
        textView.backgroundColor = .grey85
        textView.layer.cornerRadius = 4
        textView.font = .body3
        textView.text = "예) 부적절한 목적을 가진 공연이에요"
        textView.textColor = .grey70
        return textView
    }()
    
    private let reportButton = BooltiButton(title: "신고하기")

    // MARK: Init
    
    init(viewModel: ReportViewModel) {
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
        self.configureGesture()
        self.bindUIComponents()
    }
}

// MARK: - Methods

extension ReportViewController {

    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.reportButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
                owner.showToast(message: "신고를 완료했어요")
            }
            .disposed(by: self.disposeBag)
        
        self.reasonTextView.rx.didBeginEditing
            .bind(with: self) { owner, _ in
                if owner.reasonTextView.textColor == .grey70 {
                    owner.reasonTextView.text = nil
                    owner.reasonTextView.textColor = .white00
                }
            }
            .disposed(by: self.disposeBag)
        
        self.reasonTextView.rx.didEndEditing
            .bind(with: self) { owner, _ in
                guard let changedText = owner.reasonTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                
                if changedText.isEmpty {
                    owner.reasonTextView.textColor = .grey70
                    owner.reasonTextView.text = "예) 부적절한 목적을 가진 공연이에요"
                    owner.reportButton.isEnabled = false
                } else {
                    owner.reportButton.isEnabled = true
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer()
        self.view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension ReportViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.mainTitle,
                               self.subTitle,
                               self.reasonTextView,
                               self.reportButton])
        
        self.view.backgroundColor = .grey95
        self.reportButton.isEnabled = false
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

        self.subTitle.snp.makeConstraints { make in
            make.top.equalTo(self.mainTitle.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self.mainTitle)
        }
        
        self.reasonTextView.snp.makeConstraints { make in
            make.top.equalTo(self.subTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(self.mainTitle)
            make.height.equalTo(160)
        }
        
        self.reportButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
        }
    }
}
