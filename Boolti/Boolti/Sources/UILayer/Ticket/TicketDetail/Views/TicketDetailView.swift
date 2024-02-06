//
//  TicketDetailView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

import RxSwift
import RxCocoa

class TicketDetailView: UIView {

    private var isLayoutConfigured = false

    private let disposeBag = DisposeBag()

    let didCopyAddressButtonTap = PublishRelay<Void>()
    let didShowConcertDetailButtonTap = PublishRelay<Void>()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private let backgroundGradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor

        return view
    }()

    private lazy var rightCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        view.backgroundColor = .black

        return view
    }()

    private lazy var leftCircleView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.grey80.cgColor
        view.backgroundColor = .black

        return view
    }()

    private var ticketMainInformationView = TicketMainInformationView()
    private let ticketNoticeView = TicketNoticeView()
    private let ticketInquiryView = TicketInquiryView()

    // BooltiButton이랑 붙히는 거 추후에 진행할 예정
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
    
    // 아래 로직은 추후에 바꿀 예정!
    override func layoutSubviews() {
        super.layoutSubviews()

        if !isLayoutConfigured {
            self.configureBackGroundBlurViewEffect()
            self.configureBackGroundGradientView()
            self.isLayoutConfigured = true
        }
        // 아래 로직 변경해야함!..
        self.configureCircleViews()
        self.updateDetailViewHeight()
    }

    func setData(with item: TicketDetailItem) {
        self.ticketMainInformationView.setData(with: item)
        self.backgroundImageView.image = item.poster
        self.ticketInquiryView.setData(with: "\(item.hostName) (\(item.hostPhoneNumber))")
        self.ticketNoticeView.setData(with: item.notice)
    }

    private func configureUI() {
        self.layer.cornerRadius = 8
        self.backgroundColor = .black
        self.clipsToBounds = true

        self.addSubviews([
            self.backgroundImageView,
            self.backgroundGradientView,
            self.ticketMainInformationView,
            self.ticketNoticeView,
            self.ticketInquiryView,
            self.horizontalButtonStackView,
            self.rightCircleView,
            self.leftCircleView
        ])
        
        self.configureConstraints()
        self.bindUIComponents()
    }

    private func configureConstraints() {

        self.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(317)
            make.height.equalTo(1000)
        }

        self.backgroundImageView.snp.makeConstraints { make in
            make.height.equalTo(590)
            make.top.horizontalEdges.equalToSuperview()
        }

        self.backgroundGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.ticketMainInformationView.snp.makeConstraints { make in
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

    private func updateDetailViewHeight() {
        let height = self.ticketMainInformationView.bounds.height + self.ticketNoticeView.bounds.height + self.ticketInquiryView.bounds.height

        + self.horizontalButtonStackView.bounds.height + CGFloat(25)

        self.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }

    private func bindUIComponents() {
        self.copyAddressButton.rx.tap
            .bind(to: self.didCopyAddressButtonTap)
            .disposed(by: self.disposeBag)

        self.showConcertDetailButton.rx.tap
            .bind(to: didShowConcertDetailButtonTap)
            .disposed(by: self.disposeBag)
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

        let centerY = self.ticketMainInformationView.ticketMainView.posterImageView.bounds.height
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
