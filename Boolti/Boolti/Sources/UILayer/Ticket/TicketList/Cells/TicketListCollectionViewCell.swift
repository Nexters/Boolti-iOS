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
        imageView.clipsToBounds = true

        return imageView
    }()

    let ticketInformationView = TicketInformationView()

    private lazy var rightCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey50.cgColor
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
        label.textColor = .grey80
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
        label.textColor = .grey80
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
        self.configureBorder()
        self.configureSeperateLine()
    }

    func setData(with item: TicketItemEntity) {
        self.backgroundImageView.setImage(with: item.posterURLPath)
        self.posterImageView.setImage(with: item.posterURLPath)
        // MARK 요거 정리하기!
        self.numberLabel.text = " ・ 1매"
        self.ticketTypeLabel.text = item.ticketName
        self.ticketInformationView.setData(with: item)
    }

    private func configureBorder() {
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
            make.horizontalEdges.equalToSuperview().inset(self.bounds.width * 0.053)
            make.bottom.equalToSuperview().inset(self.bounds.height * 0.038)
        }

        self.posterImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(self.bounds.width * 0.053)
            make.top.equalTo(self.upperTagView.snp.bottom).offset(self.bounds.height * 0.038)
            make.height.equalTo(self.posterImageView.snp.width).multipliedBy(1.4)
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
            make.centerY.equalTo(self.snp.top).offset(self.bounds.height * 0.813)
            make.centerX.equalTo(self.snp.right)
        }

        self.leftCircleView.snp.makeConstraints { make in
            make.width.height.equalTo(self.bounds.height * 0.035)
            make.centerY.equalTo(self.snp.top).offset(self.bounds.height *  0.813)
            make.centerX.equalTo(self.snp.left)
        }
    }

        private func configureSeperateLine() {
            let path = CGMutablePath()
            let height = self.bounds.height * 0.813
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