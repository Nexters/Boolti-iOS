//
//  TicketDetailView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

class TicketDetailView: UIView {

    private var isLayoutConfigured = false

    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private var backgroundGradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey50.cgColor

        return view
    }()

    private lazy var rightCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey50.cgColor
        view.backgroundColor = .black

        return view
    }()

    private lazy var leftCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey50.cgColor
        view.backgroundColor = .black

        return view
    }()

    private var ticketMainInformationView: TicketMainInformationView?
    private let ticketNoticeView = TicketNoticeView()
    private let ticketInquiryView = TicketInquiryView()

    // BooltiButton이랑 붙히는 거 추후에 진행할 예정
    let copyAddressButton: UIButton = {
        let button = UIButton()
        button.setTitle("공연장 주소 복사", for: .normal)
        button.backgroundColor = .grey70
        button.titleLabel?.font = .subhead1
        button.setTitleColor(.grey05, for: .normal)
        button.layer.cornerRadius = 4

        return button
    }()

    let showConcertDetailButton: UIButton = {
        let button = UIButton()
        button.setTitle("공연 정보 보기", for: .normal)
        button.backgroundColor = .grey20
        button.titleLabel?.font = .subhead1
        button.setTitleColor(.grey90, for: .normal)
        button.layer.cornerRadius = 4

        return button
    }()

    private lazy var horizantalButtonStackView: UIStackView = {
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

    init(item: TicketItem) {
        super.init(frame: .zero)
        self.configureUI(with: item)
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !isLayoutConfigured {
            self.configureBackGroundBlurViewEffect()
            self.configureBackGroundGradientView()
            self.isLayoutConfigured = true
        }
        // 아래 로직 변경해야함!..
        self.configureCircleViews()
    }

    private func configureUI(with item: TicketItem) {
        self.ticketMainInformationView = TicketMainInformationView(item: item)
        self.backgroundImageView.image = item.poster
        self.ticketInquiryView.setData(with: "박불티 (010-1234-5678)")

        self.layer.cornerRadius = 8
        self.clipsToBounds = true

        self.copyAddressButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        self.showConcertDetailButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        guard let ticketMainInformationView else { return }

        self.addSubviews([
            self.backgroundImageView,
            self.backgroundGradientView,
            ticketMainInformationView,
            self.ticketNoticeView,
            self.ticketInquiryView,
            self.horizantalButtonStackView,
            self.rightCircleView,
            self.leftCircleView
        ])

        self.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(317)
            make.height.greaterThanOrEqualTo(1000)
        }

        self.backgroundImageView.snp.makeConstraints { make in
            make.height.equalTo(590)
            make.top.horizontalEdges.equalToSuperview()
        }

        self.backgroundGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        ticketMainInformationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.ticketNoticeView.snp.makeConstraints { make in
            make.top.equalTo(ticketMainInformationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }

        self.ticketInquiryView.snp.makeConstraints { make in
            make.top.equalTo(self.ticketNoticeView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }

        self.horizantalButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.ticketInquiryView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(25)
        }
    }

    private func configureBackGroundBlurViewEffect() {

        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.alpha = 0.8

        self.insertSubview(visualEffectView, aboveSubview: self.backgroundImageView)
    }

    private func configureBackGroundGradientView() {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.77, green: 0.79, blue: 0.80, alpha: 0.01).cgColor,
            UIColor.black.cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        gradientLayer.locations = [0.0, 0.6]

        gradientLayer.frame = self.bounds
        self.backgroundGradientView.layer.addSublayer(gradientLayer)
    }

    private func configureCircleViews() {

        guard let centerY = self.ticketMainInformationView?.ticketMainView.posterImageView.bounds.height else { return }
        guard centerY != 0 else { return }

        self.rightCircleView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.right)
            make.width.height.equalTo(centerY * 0.05)
            make.centerY.equalTo(centerY * 1.18)
        }

        self.leftCircleView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.left)
            make.width.height.equalTo(centerY * 0.05)
            make.centerY.equalTo(centerY * 1.18)
        }

        self.rightCircleView.layer.cornerRadius = centerY * 0.025
        self.leftCircleView.layer.cornerRadius = centerY * 0.025
    }
}
