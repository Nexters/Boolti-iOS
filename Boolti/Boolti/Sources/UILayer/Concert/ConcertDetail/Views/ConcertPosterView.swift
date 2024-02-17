//
//  ConcertPosterView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/4/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ConcertPosterView: UIView {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    private let scrollViewWidth: CGFloat = 299 * (UIScreen.main.bounds.width / 375)
    private lazy var scrollViewHeight: CGFloat = self.scrollViewWidth * 419 / 299
    
    // MARK: UI Component

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.layer.cornerRadius = 8
        scrollView.layer.borderColor = UIColor.grey80.cgColor
        scrollView.layer.borderWidth = 1
        scrollView.bounces = false
        
        scrollView.delegate = self

        return scrollView
    }()
    
    private let pageControl = UIPageControl()

    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .point3
        label.textColor = .grey05
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
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

extension ConcertPosterView {
    
    func setData(images: [ConcertDetailEntity.Poster], title: String) {
        self.addContentScrollView(images: images)
        self.titleLabel.text = title
        
        self.pageControl.isHidden = images.count <= 1
    }
    
    private func addContentScrollView(images: [ConcertDetailEntity.Poster]) {
        for index in 0..<images.count{
            let imageView = UIImageView()
            imageView.setImage(with: images[index].path)
            imageView.contentMode = .scaleToFill

            let positionX = self.scrollViewHeight * CGFloat(index)
            imageView.frame = CGRect(x: positionX, y: 0, width: self.scrollViewWidth, height: self.scrollViewHeight)

            imageView.frame.origin.x = self.scrollViewWidth * CGFloat(index)
            
            if images.count > 1 {
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = imageView.bounds
                gradientLayer.colors = [UIColor.clear.cgColor, UIColor.grey95.withAlphaComponent(0.5).cgColor]
                gradientLayer.locations = [0.85, 1.0]
                imageView.layer.addSublayer(gradientLayer)
            }
            
            self.scrollView.addSubview(imageView)
        }
        
        self.scrollView.contentSize = CGSize(
            width: self.scrollViewWidth * CGFloat(images.count),
            height: self.scrollViewHeight
        )
        self.pageControl.numberOfPages = images.count
    }
}

// MARK: - UIScrollViewDelegate

extension ConcertPosterView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(round(self.scrollView.contentOffset.x / self.scrollViewWidth))
        self.pageControl.currentPage = currentPage
    }
}

// MARK: - UI

extension ConcertPosterView {
    
    private func configureUI() {
        self.addSubviews([self.scrollView, self.pageControl, self.titleLabel])
        
        self.backgroundColor = .grey90
        self.layer.cornerRadius = 20
        self.layer.maskedCorners = CACornerMask(
            arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner
        )
        
        self.scrollView.frame = bounds
    }
    
    private func configureConstraints() {
        self.scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.scrollViewWidth)
            make.height.equalTo(self.scrollViewHeight)
        }
        
        self.pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(self.scrollView).offset(-8)
            make.centerX.equalTo(self.scrollView)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(self.scrollView)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}
