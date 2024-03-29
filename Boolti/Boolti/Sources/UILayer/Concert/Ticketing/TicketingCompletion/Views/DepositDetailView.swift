//
//  DepositDetailView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/31/24.
//

import UIKit

final class DepositDetailView: UIView {
    
    // MARK: UI Component
    
    private lazy var titleStackView = self.makeLabelStackView(subviews: [self.makeLabel(title: "은행명"),
                                                                         self.makeLabel(title: "계좌번호"),
                                                                         self.makeLabel(title: "예금주"),
                                                                         self.makeLabel(title: "입금 마감일")])
    
    private lazy var bank = self.makeLabel()
    
    private lazy var account = self.makeLabel()
    
    private lazy var accountHolder = self.makeLabel()
    
    private lazy var depositDeadline = self.makeLabel()
    
    private lazy var detailStackView = self.makeLabelStackView(subviews: [self.bank,
                                                                          self.account,
                                                                          self.accountHolder,
                                                                          self.depositDeadline])
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        
        self.configureUI()
        self.configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension DepositDetailView {
    
    func setSalesEndTime(salesEndTime: Date) {
        guard let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: salesEndTime) else { return }
        self.depositDeadline.text = endOfDay.format(.dateTime)
    }
    
    func setBankData(reservation: TicketReservationDetailEntity) {
        self.bank.text = reservation.bankName
        self.account.text = reservation.accountNumber
        self.accountHolder.text = reservation.accountHolderName
    }
}

// MARK: - UI

extension DepositDetailView {
    
    private func makeLabel(title: String = "") -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .body1
        
        if title.isEmpty {
            label.textColor = .grey15
        } else {
            label.textColor = .grey30
        }
        return label
    }
    
    private func makeLabelStackView(subviews: [UILabel]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        return stackView
    }
    
    private func configureUI() {
        self.addSubviews([self.titleStackView, self.detailStackView])
        
        self.backgroundColor = .grey90
        self.layer.cornerRadius = 4
        
        self.detailStackView.alignment = .trailing
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(144)
        }
        
        self.titleStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(100)
        }
        
        self.detailStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.left.equalTo(self.titleStackView.snp.right).offset(12)
            make.right.equalToSuperview().inset(20)
        }
    }
}
