////
////  TicketMainView.swift
////  Boolti
////
////  Created by Miro on 1/30/24.
////
//
//import UIKit
//
//class TicketMainView: UIView {
//
//    private let numberLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .grey05
//        label.font = .caption
//
//        return label
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .grey10
//        label.font = .headline1
//        label.numberOfLines = 2
//
//        return label
//    }()
//
//    private lazy var informationStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.addArrangedSubviews([self.dateLabel, self.locationLabel])
//
//        return stackView
//    }()
//
//    private let dateLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .grey30
//        label.font = .body2
//
//        return label
//    }()
//
//    private let locationLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .grey30
//        label.font = .body2
//
//        return label
//    }()
//
//    private var posterImageView: PosterImageView?
//
//    private let qrCodeImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 4
//
//        return imageView
//    }()
//
//    init(with item: UsableTicket) {
//        super.init(frame: CGRect())
//        self.setData(with: item)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setData(with item: UsableTicket) {
//
//        self.posterImageView = PosterImageView(
//            image: item.poster,
//            ellipseWidth: 28,
//            cornerRadius: 8,
//            circleColor: .grey85
//        )
//        self.dateLabel.text = item.date
//        self.locationLabel.text = " | \(item.location)"
//        self.titleLabel.text = item.title
//        self.qrCodeImageView.image = item.qrCode
//
//        guard let posterImageView else { return }
//        self.addSubviews([
//            posterImageView,
//            self.qrCodeImageView,
//            self.titleLabel,
//            self.informationStackView,
//        ])
//        self.configureConstraints()
//    }
//
//    private func configureConstraints() {
//
//        guard let posterImageView else { return }
//
//        posterImageView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.horizontalEdges.equalToSuperview()
//            make.height.equalTo(380)
//        }
//
//        self.qrCodeImageView.snp.makeConstraints { make in
//            make.top.equalTo(posterImageView.snp.bottom).offset(24)
//            make.right.equalToSuperview()
//            make.height.equalTo(80)
//            make.width.equalTo(self.qrCodeImageView.snp.height)
//        }
//
//        self.titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(self.qrCodeImageView.snp.top)
//            make.left.equalToSuperview()
//            make.right.equalTo(self.qrCodeImageView.snp.left).offset(-20)
//        }
//
//        self.informationStackView.snp.makeConstraints { make in
//            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
//            make.left.equalToSuperview()
//        }
//    }
//}
