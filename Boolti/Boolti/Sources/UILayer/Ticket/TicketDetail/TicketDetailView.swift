//
//  TicketDetailView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

class TicketDetailView: UIView {

    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }()
    private var ticketMainInformationView: TicketMainInformationView?
    private let ticketNoticeVIew = TicketNoticeView()

    init(item: TicketItem) {
        super.init(frame: .zero)
        self.configureUI(with: item)
        self.backgroundColor = .brown
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(with item: TicketItem) {
        self.ticketMainInformationView = TicketMainInformationView(item: item)
        self.backgroundImageView.image = item.poster

        guard let ticketMainInformationView else { return }

        self.addSubviews([
            self.backgroundImageView,
            ticketMainInformationView,
            self.ticketNoticeVIew
        ])

        self.snp.makeConstraints { make in
            make.width.equalTo(317)
            make.height.equalTo(1000)
        }

        self.backgroundImageView.snp.makeConstraints { make in
            make.height.equalTo(590)
            make.top.horizontalEdges.equalToSuperview()
        }

        ticketMainInformationView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        self.ticketNoticeVIew.snp.makeConstraints { make in
            make.top.equalTo(ticketMainInformationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }


    }
}
