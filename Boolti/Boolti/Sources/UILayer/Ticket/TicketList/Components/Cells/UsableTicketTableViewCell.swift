////
////  UsableTicketTableViewCell.swift
////  Boolti
////
////  Created by Miro on 1/28/24.
////
//
//import UIKit
//
//class UsableTicketTableViewCell: UITableViewCell {
//
//    private let upperTagView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .orange01
//
//        return view
//    }()
//
//    private lazy var upperTagLabelStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.addArrangedSubviews([self.ticketTypeLabel, self.numberLabel])
//
//        return stackView
//    }()
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
//    private let booltiLogoImageView: UIImageView = {
//        let imageView = UIImageView(image: .booltiLogoOrange)
//        imageView.alpha = 0.5
//
//        return imageView
//    }()
//
//    private let ticketTypeLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .grey05
//        label.font = .caption
//
//        return label
//    }()
//
//    private var ticketMainView: TicketMainView?
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.contentView.frame = contentView.frame.inset(
//            by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
//        )
//    }
//
//    func setData(with item: UsableTicket) {
//        self.contentView.backgroundColor = .grey85
//        self.backgroundColor = .grey95
//        self.contentView.clipsToBounds = true
//        self.contentView.layer.cornerRadius = 8
//
//        self.numberLabel.text = "﹒ \(item.number)매"
//        self.ticketTypeLabel.text = item.ticketType.description
//
//        self.ticketMainView = TicketMainView(with: item)
//        guard let ticketMainView else { return }
//
//        self.contentView.addSubviews([
//            self.upperTagView,
//            self.upperTagLabelStackView,
//            self.booltiLogoImageView,
//            ticketMainView
//        ])
//
//        self.configureConstraints()
//        self.configureGradient()
//        self.configureBorder()
//    }
//
//    private func configureGradient() {
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor(white: 1, alpha: 0.4).cgColor, UIColor(white: 1, alpha: 0).cgColor]
//
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.2, y: 0.3)
//
//        gradientLayer.locations = [0.0, 0.5]
//
//        gradientLayer.frame = self.bounds
//        gradientLayer.cornerRadius = 8
//        self.contentView.layer.addSublayer(gradientLayer)
//    }
//
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
//    }
//
//    private func configureConstraints() {
//
//        self.upperTagView.snp.makeConstraints { make in
//            make.horizontalEdges.top.equalToSuperview()
//            make.height.equalTo(32)
//        }
//
//        self.upperTagLabelStackView.snp.makeConstraints { make in
//            make.centerY.equalTo(self.upperTagView.snp.centerY)
//            make.left.equalToSuperview().inset(20)
//        }
//
//        self.booltiLogoImageView.snp.makeConstraints { make in
//            make.top.equalTo(self.upperTagLabelStackView)
//            make.right.equalToSuperview().inset(20)
//        }
//
//        self.ticketMainView?.snp.makeConstraints { make in
//            make.top.equalTo(self.upperTagView.snp.bottom).offset(20)
//            make.horizontalEdges.equalToSuperview().inset(20)
//        }
//    }
//}
