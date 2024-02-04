//
//  TicketMainInformationView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

class TicketMainInformationView: UIView {

    private var ticketMainView = TicketMainView()

    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let upperTagView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.4)

        return view
    }()

    init(item: TicketItem) {
        super.init(frame: .zero)
        self.configureUI(with: item)
        self.backgroundColor = .purple
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        self.configureBackGroundBlurViewEffect()
    }

    private func configureUI(with item: TicketItem) {
        self.backgroundImageView.addSubview(self.upperTagView)

        self.addSubviews([
            self.backgroundImageView,
            self.ticketMainView
        ])

        self.ticketMainView.setData(with: item)
        self.backgroundImageView.image = item.poster

        self.snp.makeConstraints { make in
            make.height.equalTo(570)
        }

        self.backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.upperTagView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(34)
        }

        self.ticketMainView.snp.makeConstraints { make in
            make.top.equalTo(self.upperTagView.snp.bottom).offset(20)
            make.height.equalTo(510)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    private func configureBackGroundBlurViewEffect() {

        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.alpha = 0.7

        self.backgroundImageView.addSubview(visualEffectView)
        self.configureBackGroundGradient()
    }

    private func configureBackGroundGradient() {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.init(white: 1, alpha: 0.1).cgColor,
            UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.7).cgColor,
        ]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        gradientLayer.frame = self.bounds
        print(self.bounds)
        self.backgroundImageView.layer.addSublayer(gradientLayer)
        self.backgroundImageView.bringSubviewToFront(self.upperTagView)
    }
}
