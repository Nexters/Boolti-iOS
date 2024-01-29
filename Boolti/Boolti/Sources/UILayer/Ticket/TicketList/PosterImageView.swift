//
//  PosterImageView.swift
//  Boolti
//
//  Created by Miro on 1/27/24.
//

import UIKit
import SnapKit

class PosterImageView: UIView {

    private lazy var rightCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        view.backgroundColor = self.circleColor

        return view
    }()

    private lazy var leftCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        view.backgroundColor = self.circleColor
        
        return view
    }()

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.grey80.cgColor
        imageView.layer.cornerRadius = self.cornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .grey90

        return imageView
    }()

    private var cornerRadius: CGFloat
    private var ellipseWidth: CGFloat
    private var circleColor: UIColor

    init(image: UIImage, ellipseWidth: Int, cornerRadius: Int, circleColor: UIColor) {
        self.ellipseWidth = CGFloat(ellipseWidth)
        self.cornerRadius = CGFloat(cornerRadius)
        self.circleColor = circleColor
        super.init(frame: CGRect())
        self.configure(with: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with image: UIImage) {
        self.posterImageView.image = image

        self.addSubviews([self.posterImageView, self.rightCircleView, self.leftCircleView])
        self.configureUI()
    }

    private func configureUI() {
        self.clipsToBounds = true

        self.rightCircleView.layer.cornerRadius = self.ellipseWidth/2
        self.leftCircleView.layer.cornerRadius = self.ellipseWidth/2

        self.rightCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(self.ellipseWidth)
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.left)
        }

        self.leftCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(self.ellipseWidth)
            make.centerY.equalToSuperview()
            make.centerX.equalTo(self.snp.right)
        }

        self.posterImageView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
