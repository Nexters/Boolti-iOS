//
//  TicketNoticeView.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

final class TicketNoticeView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "안내사항 for 주최자"
        label.font = .subhead2
        label.textColor = .grey15

        return label
    }()

    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "- 공연장 입장은 공연 30분 전부터 가능합니다. \n- 본 티켓은 타인에게 양도할 수 없습니다. \n- 입구에서 동봉한 티켓 이미지와 본인 확인이 가능한 신분증을 스태프에게 확인 후 입장 가능합니다. \n- 사전에 함께 구매하신 굿즈는 동봉한 교환증 이미지와 본인 확인이 가능한 신분증을 스태프에게 확인 후 수령 가능합니다. \n- 공연장 내 물품보관함이 별도로 존재하지 않으니 소지품을 최대한 간소화하여 오시기 바랍니다. \n- 공연장 내에서는 주류 반입이 금지되어 있습니다. 또한 캐리어 및 폭죽, 레이저와 같은 위험물질은 반입이 금지되어 있습니다."
        label.setLineSpacing(lineSpacing: 6)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .body1
        label.textColor = .grey50

        return label
    }()

    init() {
        super.init(frame: .zero)
        self.configureUI()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.addSubviews([
            self.titleLabel,
            self.noticeLabel
        ])

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.noticeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self.titleLabel)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
