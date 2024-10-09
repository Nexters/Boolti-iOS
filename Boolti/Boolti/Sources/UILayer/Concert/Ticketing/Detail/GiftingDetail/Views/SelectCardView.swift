//
//  SelectCardView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 6/25/24.
//

import UIKit

import RxSwift

final class SelectCardView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let cardWidth: CGFloat = UIScreen.main.bounds.width - 64
    private lazy var cardHeight: CGFloat = cardWidth * 1.267
    
    // MARK: UI Component
    
    private let selectedCardBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.white00.withAlphaComponent(0.4).cgColor
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = .subhead2
        textView.text = "공연에 초대합니다."
        textView.backgroundColor = .clear
        textView.textColor = .white00
        textView.textAlignment = .center
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.tintColor = .white00
        return textView
    }()
    
    private let messageCountLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .caption
        label.textColor = .grey10
        return label
    }()
    
    lazy var cardImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .init(top: 0, left: 32, bottom: 0, right: 32)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(CardImageCollectionViewCell.self, forCellWithReuseIdentifier: CardImageCollectionViewCell.className)
        return collectionView
    }()
    
    // MARK: Initailizer
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.bindUIComponent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

// MARK: - Methods

extension SelectCardView {
    
    func setSelectedImage(with imageURL: String) {
        self.selectedCardBackgroundImageView.setImage(with: imageURL)
    }
    
    private func bindUIComponent() {
        self.messageTextView.rx.text
            .bind(with: self) { owner, changedText in
                guard let changedText = changedText else { return }
                
                if changedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.messageTextView.text = ""
                } else if changedText.count > 40 {
                    owner.messageTextView.deleteBackward()
                }
                
                owner.messageTextView.setLineHeight(alignment: .center)
                owner.messageCountLabel.text = "\(changedText.count)/40자"
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SelectCardView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
}

// MARK: - UI

extension SelectCardView {
    
    private func configureUI() {
        self.addSubviews([self.selectedCardBackgroundImageView,
                          self.messageTextView,
                          self.messageCountLabel,
                          self.cardImageCollectionView])
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.cardHeight + 140)
        }
        
        self.selectedCardBackgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(self.cardHeight)
        }
        
        self.messageTextView.snp.makeConstraints { make in
            make.top.equalTo(self.selectedCardBackgroundImageView).inset(32)
            make.horizontalEdges.equalTo(self.selectedCardBackgroundImageView).inset(20)
            make.height.lessThanOrEqualTo(80)
        }
        
        self.messageCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.messageTextView.snp.bottom).offset(12)
        }
        
        self.cardImageCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.selectedCardBackgroundImageView.snp.bottom).offset(32)
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
}
