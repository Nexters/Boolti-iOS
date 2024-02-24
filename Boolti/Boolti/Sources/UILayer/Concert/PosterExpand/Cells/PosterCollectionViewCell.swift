//
//  PosterCollectionViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/25/24.
//

import UIKit

final class PosterCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Component

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.addSubview(self.imageView)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 637 * (UIScreen.main.bounds.height / 812)))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

// MARK: - Methods

extension PosterCollectionViewCell {
 
    func setData(with path: String) {
        self.imageView.setImage(with: path)
    }
}

// MARK: - UIScrollViewDelegate

extension PosterCollectionViewCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return self.imageView
     }
}

// MARK: - UI

extension PosterCollectionViewCell {
    
    private func configureUI() {
        self.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
