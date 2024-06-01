import UIKit
import SnapKit

class GradientBackgroundView: UIView {

    private let upperTagView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.4)
        return view
    }()


    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8

        return view
    }()

    private let tagLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .pretendardB(14)
        label.textColor = .grey80
        return label
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .booltiLogo
        return imageView
    }()

    private lazy var gradientView: UIView = {
        let view = UIView()
        view.layer.insertSublayer(self.gradientLayer, at: 0)
        return view
    }()

    private let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.grey95.withAlphaComponent(0.5).cgColor,
            UIColor.grey95.withAlphaComponent(0.8).cgColor,
            UIColor.grey95.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1)
        gradientLayer.locations = [0.4, 0.9]
        return gradientLayer
    }()

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
        view.layer.borderColor = UIColor.grey50.cgColor
        view.backgroundColor = .grey95

        return view
    }()

    private let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [5, 5]
        shapeLayer.strokeColor = UIColor(white: 1, alpha: 0.3).cgColor
        return shapeLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with posterImageURL: String, concertName: String) {
        self.posterImageView.setImage(with: posterImageURL)
        self.tagLabel.text = concertName
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.posterImageView.bounds
        self.configureCircleViews()
        self.updateSeperateLinePoint()
        self.configureGradientBorder()
    }

    private func configureUI() {
        self.clipsToBounds = true
        self.backgroundColor = .grey95
        self.layer.cornerRadius = 8

        self.addSubviews([
            self.posterImageView,
            self.gradientView,
            self.borderView,
            self.leftCircleView,
            self.rightCircleView,
            self.upperTagView,
            self.tagLabel,
            self.logoImageView
        ])

        self.layer.addSublayer(self.shapeLayer)

        self.configureConstraints()
        self.configureBackGroundBlurViewEffect()
    }

    private func configureConstraints() {

        self.upperTagView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(34)
            make.width.equalToSuperview()
        }

        self.posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(500)
        }

        self.gradientView.snp.makeConstraints { make in
            make.edges.equalTo(self.posterImageView)
        }

        self.leftCircleView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.left)
            make.width.height.equalTo(20)
            make.centerY.equalTo(self.snp.top).offset(465)
        }

        self.rightCircleView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.right)
            make.width.height.equalTo(20)
            make.centerY.equalTo(self.snp.top).offset(465)
        }

        self.borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.tagLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.upperTagView)
            make.left.equalToSuperview().inset(20)
        }

        self.logoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.upperTagView)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(16)
        }
    }

    private func configureBackGroundBlurViewEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        self.posterImageView.addSubview(visualEffectView)

        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureCircleViews() {
        self.leftCircleView.layer.cornerRadius = self.leftCircleView.bounds.width / 2
        self.rightCircleView.layer.cornerRadius = self.rightCircleView.bounds.width / 2
    }

    private func updateSeperateLinePoint() {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 20, y: 465))
        path.addLine(to: CGPoint(x: self.frame.width - 20, y: 465))

        self.shapeLayer.path = path
    }

    private func configureGradientBorder() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.borderView.bounds
        gradientLayer.colors = [UIColor.grey80.cgColor, UIColor.grey50.cgColor, UIColor.grey10.cgColor]

        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)

        gradientLayer.locations = [0.1, 0.7, 0.9]

        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let gradient =  renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }

        let gradientColor = UIColor(patternImage: gradient)
        self.borderView.layer.borderColor = gradientColor.cgColor
        self.borderView.layer.borderWidth = 1
    }
}
