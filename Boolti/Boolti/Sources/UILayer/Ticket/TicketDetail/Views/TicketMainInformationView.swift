//
//  TicketMainInformationView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

class TicketMainInformationView: UIView {

    let ticketMainView = TicketMainView()

    private let upperTagView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.4)

        return view
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(with item: TicketDetailItem) {
        // 다른 방법 생각해보기!..
        // TicketDetailItem이 TicketItem을 가지고 있는 것도 생각해보기!..
        let ticketItem = TicketItem(
            ticketType: item.ticketType,
            ticketName: item.ticketName,
            poster: item.poster,
            title: item.title,
            date: item.date,
            location: item.location,
            qrCode: item.qrCode,
            ticketID: item.ticketID,
            isUsed: item.isUsed
        )
        self.ticketMainView.setData(with: ticketItem, limitNumberOfLines: true)
    }

    private func configureUI() {

        self.addSubviews([
            self.upperTagView,
            self.ticketMainView
        ])


        self.upperTagView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(34)
        }

        self.ticketMainView.snp.makeConstraints { make in
            make.top.equalTo(self.upperTagView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
