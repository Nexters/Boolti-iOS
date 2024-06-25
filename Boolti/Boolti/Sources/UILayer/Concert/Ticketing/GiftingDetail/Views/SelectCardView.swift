//
//  SelectCardView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 6/25/24.
//

import UIKit

final class SelectCardView: UIView {
    
    // MARK: Properties
    
    private let cardWidth: CGFloat = UIScreen.main.bounds.width - 64
    private lazy var cardHeight: CGFloat = cardWidth * 1.23
    
    // MARK: UI Component
    
    private lazy var selectedCardBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.init("FFA883").cgColor
        view.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = .init(x: 0, y: 0, width: self.cardWidth, height: self.cardHeight)
        gradientLayer.colors = [UIColor.init("FF5A14").cgColor,
                                UIColor.init("FFA883").cgColor]
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    private let messageTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        textView.font = .subhead2
        textView.text = "공연에 초대합니다."
        textView.backgroundColor = .clear
        textView.textColor = .white00
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        return textView
    }()
    
    private let messageCountLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .caption
        label.textColor = .grey10
        label.text = "0/40자"
        label.setAlignment(.center)
        return label
    }()
    
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white00
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: Initailizer
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - Methods

extension SelectCardView {
    
    private func configureUI() {
        self.addSubviews([self.selectedCardBackgroundView,
                          self.messageTextView,
                          self.messageCountLabel,
                          self.selectedImageView])
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(cardHeight + 156)
        }
        
        self.selectedCardBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(self.cardHeight)
        }
        
        self.messageTextView.snp.makeConstraints { make in
            make.top.equalTo(self.selectedCardBackgroundView).inset(32)
            make.horizontalEdges.equalTo(self.selectedCardBackgroundView).inset(20)
        }
        
        self.messageCountLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.messageTextView)
            make.bottom.equalTo(self.selectedImageView.snp.top).offset(-28)
        }
        
        self.selectedImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.messageTextView)
            make.height.equalTo((self.cardWidth - 40) * (2/3))
            make.bottom.equalTo(self.selectedCardBackgroundView).inset(32)
        }
    }
    
}
