//
//  TicketNoticeView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

final class TicketNoticeView: UIView {

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.text = "안내사항 for 주최자"
        label.textColor = .grey15

        return label
    }()

    private let noticeTextView: UITextView = {
        let textView = UITextView()
        textView.font = .body1
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.backgroundColor = .clear
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.textColor = .grey50
        textView.linkTextAttributes = [.underlineStyle: 1, .foregroundColor: UIColor.init("#46A6FF")]

        return textView
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubviews([
            self.titleLabel,
            self.noticeTextView
        ])

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview()
        }

        self.noticeTextView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self.titleLabel)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    func setData(with text: String) {
        if text.isEmpty || text == "undefined" {
            self.noticeTextView.text = "-"
        } else {
            self.noticeTextView.text = text
        }
        self.noticeTextView.setLineHeight(alignment: .left)
    }
}
