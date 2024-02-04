//
//  TicketingPeriodView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/4/24.
//

import UIKit

final class TicketingPeriodView: UIView {
    
    // MARK: UI Component
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "•  티켓 예매 기간  •"
        label.font = .subhead1
        label.textColor = .grey15
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

// MARK: - UI

extension TicketingPeriodView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // 마스크(잘라낼 부분) 만들기
        let path =  UIBezierPath(roundedRect: rect, cornerRadius: 8)
        
        let leftCenter = CGPoint(x: rect.minX, y: rect.height / 2)
        path.move(to: leftCenter)
        path.addArc(withCenter: leftCenter, radius: 8, startAngle: 3 / 2 * .pi, endAngle: 1 / 2 * .pi, clockwise: true)
        
        let rightCenter = CGPoint(x: rect.maxX, y: rect.height / 2)
        path.move(to: rightCenter)
        path.addArc(withCenter: rightCenter, radius: 8, startAngle: 3 / 2 * .pi, endAngle: 1 / 2 * .pi, clockwise: false)

        // 마스크 적용
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.fillRule = .evenOdd
        layer.mask = mask
        
        // 티켓 모양 마스크 만들기
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 1.0
        shapeLayer.strokeColor = UIColor.white00.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor

        // 그라데이션 레이어 생성
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [UIColor.init("#DBCBCB").cgColor, UIColor.init("#4E4E4E").cgColor, UIColor.init("#C2C2C2").cgColor]
        gradientLayer.locations = [0, 0.5, 1.0]
        
        // 그라데이션 레이어에 티켓 모양 마스크 적용
        gradientLayer.mask = shapeLayer
        
        layer.addSublayer(gradientLayer)
    }
    
    private func configureUI() {
        self.addSubviews([self.titleLabel])
        
        self.backgroundColor = .grey70
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(88)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
    }
}
