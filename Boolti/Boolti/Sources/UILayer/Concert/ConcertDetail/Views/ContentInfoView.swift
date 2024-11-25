//
//  ContentInfoView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/5/24.
//

import UIKit

import RxCocoa

final class ContentInfoView: UIView {
    
    // MARK: UI Component
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey10
        label.font = .subhead2
        label.text = "내용"
        
        return label
    }()
    
    private let expandButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 40, bottom: 2, trailing: 0)
        config.title = "전체보기"
        config.attributedTitle?.font = .body1
        config.baseForegroundColor = .grey50
        
        let button = UIButton(configuration: config)
        return button
    }()

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.font = .body3
        textView.textColor = .grey30
        textView.linkTextAttributes = [.underlineStyle: 1, .foregroundColor: UIColor.init("#46A6FF")]
        
        return textView
    }()
    
    private let underLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .grey85
        
        return view
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Methods

extension ContentInfoView {
    
    func setData(content: String) {
        self.contentTextView.text = content
        self.contentTextView.setLineSpacing(lineSpacing: 6)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(106 + min(self.contentTextView.getTextViewHeight(), 246))
        }
    }
    
    func didAddressExpandButtonTap() -> Signal<Void> {
        return self.expandButton.rx.tap.asSignal()
    }
}

// MARK: - UI

extension ContentInfoView {
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.expandButton, self.contentTextView, self.underLineView])
    }
    
    private func configureConstraints() {
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.expandButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.right.equalTo(self.titleLabel)
        }
        
        self.contentTextView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(self.titleLabel)
            make.height.lessThanOrEqualTo(246)
        }
        
        self.underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(self.contentTextView)
        }
    }
}

