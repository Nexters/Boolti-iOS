//
//  EditIntroductionView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/5/24.
//

import UIKit

import RxSwift
import RxCocoa

// TODO: EditIntroductionView - TextView의 PlaceHolder등 추가해서 리팩토링 진행하기
final class EditIntroductionView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Components
    private let introductionLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.textColor = .grey10
        label.text = "소개"
        return label
    }()
    
    let introductionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .grey85
        textView.font = .body3
        textView.text = "예) 재즈와 펑크락을 좋아해요"
        textView.textColor = .grey70
        textView.isScrollEnabled = false
        return textView
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 4
        return view
    }()

    private let textCountLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .caption
        label.textColor = .grey70
        return label
    }()
    
    // MARK: Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.bindTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension EditIntroductionView {
    
    func setData(with introduction: String?) {
        guard let introduction = introduction else { return }
        
        if !introduction.isEmpty {
            self.introductionTextView.textColor = .grey10
            self.introductionTextView.text = introduction
            self.textCountLabel.text = "\(introduction.count)/60자"
        }
    }

    private func bindTextView() {
        self.introductionTextView.rx.didBeginEditing
            .bind(with: self) { owner, _ in
                if owner.introductionTextView.textColor == .grey70 {
                    owner.introductionTextView.text = nil
                    owner.introductionTextView.textColor = .grey10
                }
            }
            .disposed(by: self.disposeBag)
        
        self.introductionTextView.rx.didEndEditing
            .bind(with: self) { owner, _ in
                guard let changedText = owner.introductionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
                
                if changedText.isEmpty {
                    owner.introductionTextView.textColor = .grey70
                    owner.introductionTextView.text = "예) 재즈와 펑크락을 좋아해요"
                }
            }
            .disposed(by: self.disposeBag)
        
        self.introductionTextView.rx.text
            .asDriver()
            .drive(with: self) { owner, changedText in
                guard let changedText = changedText else { return }
                
                if changedText.count > 60 {
                    owner.introductionTextView.deleteBackward()
                }
                
                if owner.introductionTextView.textColor == .grey10 {
                    owner.textCountLabel.text = "\(changedText.count)/60자"
                } else {
                    owner.textCountLabel.text = "0/60자"
                }
                
                owner.introductionTextView.setLineHeight(alignment: .left)
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UI

extension EditIntroductionView {
    
    private func configureUI() {
        self.backgroundColor = .grey90
        self.addSubviews([self.introductionLabel,
                          self.backgroundView,
                          self.introductionTextView,
                          self.textCountLabel])
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.introductionLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }

        self.introductionTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(32)
            make.top.equalToSuperview().inset(74)
            make.bottom.equalToSuperview().inset(58)
            make.height.greaterThanOrEqualTo(72)
        }

        self.backgroundView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(122)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(self.introductionLabel.snp.bottom).offset(16)
            make.bottom.equalTo(self.introductionTextView.snp.bottom).offset(38)
        }
        
        self.textCountLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self.backgroundView).inset(12)
        }

        self.snp.makeConstraints { make in
            make.bottom.equalTo(self.backgroundView.snp.bottom).offset(20)
        }
    }
}
