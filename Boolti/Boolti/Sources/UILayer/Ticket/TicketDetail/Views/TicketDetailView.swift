//
//  TicketDetailView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

import RxSwift
import RxCocoa

final class TicketDetailView: UIView {

    private let disposeBag = DisposeBag()

    let didCopyAddressButtonTap = PublishRelay<Void>()
    let didShowConcertDetailButtonTap = PublishRelay<Void>()

    // 더 좋은 방법 생각해보기!..
    private var isSeperatedLineConfigured = false

    private let upperTagView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.4)

        return view
    }()

    private let backgroundBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor

        return view
    }()

    // MARK: upperTagLabelStackView 처리하기
    private let ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey80
        label.font = .pretendardB(14)

        return label
    }()

    private let booltiLogoImageView: UIImageView = {
        let imageView = UIImageView(image: .booltiLogo)

        return imageView
    }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true

        return imageView
    }()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    let ticketDetailInformationView = TicketDetailInformationView()

    private let rightCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        view.backgroundColor = .grey95

        return view
    }()

    private let leftCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        view.backgroundColor = .grey95

        return view
    }()

    private let ticketNoticeView = TicketNoticeView()
    private let ticketInquiryView = TicketInquiryView()

    //     BooltiButton이랑 붙히는 거 추후에 진행할 예정
    private let copyAddressButton: UIButton = {
        let button = UIButton()
        button.setTitle("공연장 주소 복사", for: .normal)
        button.backgroundColor = .grey70
        button.titleLabel?.font = .subhead1
        button.setTitleColor(.grey05, for: .normal)
        button.layer.cornerRadius = 4

        return button
    }()

    private let showConcertDetailButton: UIButton = {
        let button = UIButton()
        button.setTitle("공연 정보 보기", for: .normal)
        button.backgroundColor = .grey20
        button.titleLabel?.font = .subhead1
        button.setTitleColor(.grey90, for: .normal)
        button.layer.cornerRadius = 4

        return button
    }()

    private lazy var horizontalButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubviews([
            self.copyAddressButton,
            self.showConcertDetailButton
        ])
        stackView.spacing = 9
        stackView.distribution = .fillEqually

        return stackView
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.bindUIComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with item: TicketDetailItemEntity) {
        self.ticketDetailInformationView.setData(with: item)
        self.posterImageView.setImage(with: item.posterURLPath)
        self.backgroundImageView.setImage(with: item.posterURLPath)
        self.ticketTypeLabel.text = "\(item.ticketName) ・ 1매"
        self.ticketInquiryView.setData(with: "\(item.hostName) (\(item.hostPhoneNumber))")
        self.ticketNoticeView.setData(with: item.notice)

        self.configureBackGroundBlurViewEffect()
        self.configureCircleViews()
        self.configureSeperateLine()
        self.updateHeight()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateHeight()
    }

    private func configureUI() {
        self.layer.cornerRadius = 8
        self.backgroundColor = .grey95
        self.clipsToBounds = true

        self.addSubviews([
            self.backgroundImageView,
            self.upperTagView,
            self.booltiLogoImageView,
            self.ticketTypeLabel,
            self.posterImageView,
            self.backgroundBorderView,
            self.ticketDetailInformationView,
            self.ticketNoticeView,
            self.ticketInquiryView,
            self.horizontalButtonStackView,
            self.rightCircleView,
            self.leftCircleView
        ])

        self.configureConstraints()
    }

    private func configureConstraints() {

        self.snp.makeConstraints { make in
            make.height.equalTo(1000)
        }

        self.upperTagView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(34)
        }

        self.posterImageView.snp.makeConstraints { make in
            make.top.equalTo(self.upperTagView.snp.bottom).offset(20)
            make.height.equalTo(400)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.backgroundBorderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.booltiLogoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.upperTagView.snp.centerY)
            make.right.equalTo(self.posterImageView)
        }

        self.ticketTypeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.booltiLogoImageView.snp.centerY)
            make.left.equalToSuperview().inset(20)
        }

        self.ticketDetailInformationView.snp.makeConstraints { make in
            make.top.equalTo(self.posterImageView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
        }

        self.backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(569)
        }

        self.rightCircleView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.right)
            make.width.height.equalTo(20)
            make.centerY.equalTo(self.posterImageView.snp.bottom).offset(20)
        }

        self.leftCircleView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.left)
            make.width.height.equalTo(20)
            make.centerY.equalTo(self.posterImageView.snp.bottom).offset(20)
        }

        self.ticketNoticeView.snp.makeConstraints { make in
            make.top.equalTo(ticketDetailInformationView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }

        self.ticketInquiryView.snp.makeConstraints { make in
            make.top.equalTo(self.ticketNoticeView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }

        self.horizontalButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.ticketInquiryView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.copyAddressButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        self.showConcertDetailButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }

    private func configureBackGroundBlurViewEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.backgroundImageView.bounds
        self.backgroundImageView.addSubview(visualEffectView)

        self.configureBackGroundGradient()
    }

    private func configureBackGroundGradient() {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.77, green: 0.79, blue: 0.80, alpha: 0.7).cgColor,
                                UIColor(red: 0.04, green: 0.04, blue: 0.04, alpha: 0.7).cgColor]

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        gradientLayer.frame = self.backgroundImageView.bounds
        self.backgroundImageView.layer.addSublayer(gradientLayer)
        self.backgroundImageView.bringSubviewToFront(self.upperTagView)
    }

    private func configureCircleViews() {
        self.leftCircleView.layer.cornerRadius = self.leftCircleView.bounds.width / 2
        self.rightCircleView.layer.cornerRadius = self.rightCircleView.bounds.width / 2
    }

    private func configureSeperateLine() {

        let path = CGMutablePath()

        path.move(to: CGPoint(x: 20, y: 475))
        path.addLine(to: CGPoint(x: self.bounds.width-20, y: 475))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [5, 5]
        shapeLayer.strokeColor = UIColor.init(white: 1, alpha: 0.3).cgColor
        self.layer.addSublayer(shapeLayer)
    }

    private func bindUIComponents() {
        self.copyAddressButton.rx.tap
            .bind(to: self.didCopyAddressButtonTap)
            .disposed(by: self.disposeBag)

        self.showConcertDetailButton.rx.tap
            .bind(to: didShowConcertDetailButtonTap)
            .disposed(by: self.disposeBag)
    }

    private func updateHeight() {
        let height = self.upperTagView.bounds.height + self.posterImageView.bounds.height + self.ticketDetailInformationView.bounds.height + self.ticketInquiryView.bounds.height + self.horizontalButtonStackView.bounds.height + 100 + self.ticketNoticeView.bounds.height

        self.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}
