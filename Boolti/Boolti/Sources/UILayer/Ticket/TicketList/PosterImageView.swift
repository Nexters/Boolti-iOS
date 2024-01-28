//
//  PosterImageView.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import UIKit
import SnapKit

class PosterImageView: UIView {

    private let rightCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        view.backgroundColor = .grey90

        return view
    }()

    private let leftCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        view.backgroundColor = .grey90
        return view
    }()

    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.grey80.cgColor
        imageView.backgroundColor = .grey90

        return imageView
    }()

    init(image: UIImage, ellipseWidth: Int) {
        super.init(frame: CGRect())
        self.configure(with: image, ellipseWidth: CGFloat(ellipseWidth))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with image: UIImage, ellipseWidth: CGFloat) {
        self.posterImageView.image = image

        self.addSubviews([self.posterImageView, self.rightCircleView, self.leftCircleView])
        self.configureUI(ellipseWidth: ellipseWidth)
    }

    private func configureUI(ellipseWidth: CGFloat) {
        self.clipsToBounds = true

        self.rightCircleView.layer.cornerRadius = ellipseWidth/2
        self.leftCircleView.layer.cornerRadius = ellipseWidth/2
        
        self.rightCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(ellipseWidth)
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.left)
        }

        self.leftCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(ellipseWidth)
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.right)
        }

        self.posterImageView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
