////
////  UsableTicketTableViewCell.swift
////  Boolti
////
////  Created by Miro on 1/28/24.
////

import UIKit

final class TicketListCollectionViewCell: UICollectionViewCell {

    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.grey50.cgColor

        return imageView
    }()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    let ticketInformationView = TicketInformationView()

    private lazy var rightCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        view.backgroundColor = .grey95

        return view
    }()

    private lazy var leftCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey50.cgColor
        view.backgroundColor = .grey95

        return view
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
        label.textColor = .grey80.withAlphaComponent(0.85)
        label.font = .pretendardB(14)

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
        label.textColor = .grey80.withAlphaComponent(0.8)
        label.font = .pretendardB(14)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.ticketInformationView.resetData()
    }

    private func configureUI() {
        self.backgroundImageView.addSubview(self.upperTagView)
        self.addSubviews([
            self.backgroundImageView,
            self.posterImageView,
            self.upperTagLabelStackView,
            self.booltiLogoImageView,
            self.ticketInformationView,
            self.rightCircleView,
            self.leftCircleView
        ])

        self.layer.cornerRadius = 8
        self.clipsToBounds = true

        self.configureBackGroundBlurViewEffect()
        self.configureConstraints()
        self.configureCircleView()
        self.configureSeperateLine()
        self.configureCornerGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureGradientBorder()
    }

    func setData(with item: TicketItemEntity) {
        self.backgroundImageView.setImage(with: item.posterURLPath)
        self.posterImageView.setImage(with: item.posterURLPath)
        self.numberLabel.text = " ・ 1매"
        self.ticketTypeLabel.text = item.ticketName
        self.ticketInformationView.setData(with: item)
    }

    private func configureCornerGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 105, height: 105)
        gradientLayer.colors = [UIColor.white00.withAlphaComponent(0.6).cgColor, UIColor.white00.withAlphaComponent(0.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.locations = [0.0, 1.0]

        self.layer.addSublayer(gradientLayer)
    }

    private func configureCircleView() {
        self.rightCircleView.layer.cornerRadius = self.bounds.height * 0.0175
        self.leftCircleView.layer.cornerRadius = self.bounds.height * 0.0175
    }

    private func configureBackGroundBlurViewEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        self.backgroundImageView.addSubview(visualEffectView)

        self.configureBackGroundGradient()
    }

    private func configureGradientBorder() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.backgroundImageView.bounds
        gradientLayer.colors = [UIColor.grey80.cgColor, UIColor.grey50.cgColor, UIColor.grey10.cgColor]

        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        gradientLayer.locations = [0.1, 0.7, 0.9]

        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let gradient =  renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }

        let gradientColor = UIColor(patternImage: gradient)
        self.backgroundImageView.layer.borderColor = gradientColor.cgColor
        self.backgroundImageView.layer.borderWidth = 1
    }

    private func configureBackGroundGradient() {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.77, green: 0.79, blue: 0.80, alpha: 0.7).cgColor,
                                UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.7).cgColor]

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        gradientLayer.frame = self.bounds
        self.backgroundImageView.layer.addSublayer(gradientLayer)
        self.backgroundImageView.bringSubviewToFront(self.upperTagView)
    }

    private func configureConstraints() {

        self.backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.upperTagView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(self.snp.height).multipliedBy(0.06)
        }

        self.ticketInformationView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(self.bounds.width * 0.06)
            make.bottom.equalToSuperview().inset(self.bounds.height * 0.04)
        }

        self.posterImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(self.bounds.width * 0.06)
            make.top.equalTo(self.upperTagView.snp.bottom).offset(self.bounds.height * 0.04)
            make.height.equalToSuperview().multipliedBy(0.67)
        }

        self.upperTagLabelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(self.upperTagView.snp.centerY)
            make.left.equalTo(self.ticketInformationView)
        }

        self.booltiLogoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.upperTagView.snp.centerY)
            make.right.equalTo(self.ticketInformationView)
        }

        self.rightCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(self.bounds.height * 0.035)
            make.centerY.equalTo(self.snp.top).offset(self.bounds.height * 0.805)
            make.centerX.equalTo(self.snp.right)
        }

        self.leftCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(self.bounds.height * 0.035)
            make.centerY.equalTo(self.snp.top).offset(self.bounds.height *  0.805)
            make.centerX.equalTo(self.snp.left)
        }
    }

        private func configureSeperateLine() {
            let path = CGMutablePath()
            let height = self.bounds.height * 0.805
            let width = self.bounds.width * 0.053

            path.move(to: CGPoint(x: width, y: height))
            path.addLine(to: CGPoint(x: self.bounds.width * 0.947, y: height))

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path
            shapeLayer.lineWidth = 2
            shapeLayer.lineDashPattern = [5, 5]
            shapeLayer.strokeColor = UIColor.init(white: 1, alpha: 0.3).cgColor
            self.layer.addSublayer(shapeLayer)
        }
}
