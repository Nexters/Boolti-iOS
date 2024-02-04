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
    
    private var periodLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead1
        label.textColor = .grey30
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

// MARK: - Methods

extension TicketingPeriodView {
    
    func setData(startDate: Date, endDate: Date) {
        self.periodLabel.text = "\(startDate.format(.date)) - \(endDate.format(.date))"
    }
}

// MARK: - UI

extension TicketingPeriodView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // 티켓 테두리 마스크(잘라낼 부분) 만들기
        let rectPath =  UIBezierPath(roundedRect: rect, cornerRadius: 8)
        
        let leftCenter = CGPoint(x: rect.minX, y: rect.midY)
        rectPath.move(to: leftCenter)
        rectPath.addArc(withCenter: leftCenter, radius: 8, startAngle: 3 / 2 * .pi, endAngle: 1 / 2 * .pi, clockwise: true)
        
        let rightCenter = CGPoint(x: rect.maxX, y: rect.midY)
        rectPath.move(to: rightCenter)
        rectPath.addArc(withCenter: rightCenter, radius: 8, startAngle: 3 / 2 * .pi, endAngle: 1 / 2 * .pi, clockwise: false)

        // 티켓 테두리 마스크 적용
        let ticketMask = CAShapeLayer()
        ticketMask.path = rectPath.cgPath
        ticketMask.fillRule = .evenOdd
        self.layer.mask = ticketMask
        
        // 티켓 모양 마스크 만들기
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = rectPath.cgPath
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
        
        self.layer.addSublayer(gradientLayer)
        
        // 점선 만들기
        let linePath = UIBezierPath()
        linePath.move(to: leftCenter)
        linePath.addLine(to: rightCenter)
        
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.black100.cgColor
        lineLayer.lineDashPattern = [7]
             
        lineLayer.path = linePath.cgPath
        self.layer.addSublayer(lineLayer)
    }
    
    private func configureUI() {
        self.addSubviews([self.titleLabel, self.periodLabel])
        
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
        
        self.periodLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
    }
}
