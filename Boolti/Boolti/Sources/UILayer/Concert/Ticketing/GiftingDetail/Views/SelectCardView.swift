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
    
    let messageTextView: UITextView = {
        let textView = UITextView()
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
        return label
    }()
    
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white00
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var cardImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .init(top: 0, left: 32, bottom: 0, right: 32)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    private func bindUIComponent() {
        self.messageTextView.rx.text
            .bind(with: self) { owner, changedText in
                guard let changedText = changedText else { return }
                
                if changedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.messageTextView.text = ""
                } else if changedText.count > 40 {
                    owner.messageTextView.deleteBackward()
                }
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

// MARK: - UICollectionViewDataSource

extension SelectCardView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardImageCollectionViewCell.className, for: indexPath) as? CardImageCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        //        cell.setData(with: "")
        return cell
    }
    
}

// MARK: - UI

extension SelectCardView {
    
    private func configureUI() {
        self.addSubviews([self.selectedCardBackgroundView,
                          self.messageTextView,
                          self.messageCountLabel,
                          self.selectedImageView,
                          self.cardImageCollectionView])
        
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
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.selectedImageView.snp.top).offset(-28)
        }
        
        self.selectedImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.messageTextView)
            make.height.equalTo((self.cardWidth - 40) * (2/3))
            make.bottom.equalTo(self.selectedCardBackgroundView).inset(32)
        }
        
        self.cardImageCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.selectedCardBackgroundView.snp.bottom).offset(44)
            make.bottom.equalToSuperview().inset(36)
        }
    }
    
}
