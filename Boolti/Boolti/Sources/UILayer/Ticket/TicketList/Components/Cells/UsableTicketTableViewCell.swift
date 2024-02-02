////
////  UsableTicketTableViewCell.swift
////  Boolti
////
////  Created by Miro on 1/28/24.
////

import UIKit

class UsableTicketTableViewCell: UICollectionViewCell {

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

    private lazy var upperTagLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubviews([self.ticketTypeLabel, self.numberLabel])

        return stackView
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey80
        label.font = .caption

        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey10
        label.font = .headline1
        label.numberOfLines = 2

        return label
    }()

    private let booltiLogoImageView: UIImageView = {
        let imageView = UIImageView(image: .booltiLogo)
        return imageView
    }()

    private let ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey80
        label.font = .caption

        return label
    }()

    private var ticketMainView: TicketMainView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        self.addSubviews([
            self.backgroundImageView,
            self.upperTagView,
            self.upperTagLabelStackView,
            self.booltiLogoImageView,
            //            ticketMainView
        ])
//        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.configureConstraints()
        self.configureBackGroundBlurViewEffect()
    }

    func setData(with item: TicketItem) {
        self.backgroundImageView.image = item.poster


        self.numberLabel.text = "﹒ \(item.number)매"
        self.ticketTypeLabel.text = item.ticketType

        //        self.ticketMainView = TicketMainView(with: item)
        //        guard let ticketMainView else { return }
        //        self.configureBlurViewGradient()

    }

    //    override func prepareForReuse() {
    //        self.configureBlurViewGradient()
    //    }

    private func configureBackGroundBlurViewEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        self.backgroundImageView.addSubview(visualEffectView)
        
        self.configureBackGroundGradient()
    }

    private func configureBackGroundGradient() {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.77, green: 0.79, blue: 0.80, alpha: 0.8).cgColor,
                                UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.8).cgColor]

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        gradientLayer.frame = self.bounds
        self.backgroundImageView.layer.addSublayer(gradientLayer)
    }

    //    private func configureBorder() {
    //        let gradientLayer = CAGradientLayer()
    //        gradientLayer.frame = self.contentView.bounds
    //        gradientLayer.colors = [UIColor.grey60.cgColor, UIColor.grey80.cgColor, UIColor.grey10.cgColor]
    //
    //        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
    //        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
    //
    //        gradientLayer.locations = [0.1, 0.5, 0.9]
    //
    //        let renderer = UIGraphicsImageRenderer(bounds: bounds)
    //        let gradient =  renderer.image { ctx in
    //            gradientLayer.render(in: ctx.cgContext)
    //        }
    //
    //        let gradientColor = UIColor(patternImage: gradient)
    //        self.contentView.layer.borderColor = gradientColor.cgColor
    //        self.contentView.layer.borderWidth = 1
    //}

    private func configureConstraints() {

        self.backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.upperTagView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(32)
        }

        self.upperTagLabelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.upperTagView.snp.centerY)
            make.left.equalToSuperview().inset(20)
        }

        self.booltiLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.upperTagLabelStackView)
            make.right.equalToSuperview().inset(20)
        }

        //        self.ticketMainView?.snp.makeConstraints { make in
        //            make.top.equalTo(self.upperTagView.snp.bottom).offset(20)
        //            make.horizontalEdges.equalToSuperview().inset(20)
        //        }
    }
}
