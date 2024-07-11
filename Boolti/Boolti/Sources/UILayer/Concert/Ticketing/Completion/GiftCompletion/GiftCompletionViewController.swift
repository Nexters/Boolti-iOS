//
//  GiftCompletionViewController.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import UIKit

final class GiftCompletionViewController: BooltiViewController {

    let viewModel: GiftCompletionViewModel

    // 선물하기 티켓일 경우 -> 추후에 분기처리해야됨!
    private lazy var kakaoGiftButton = SocialServiceButton(title: "받는 분 선택하기", type: .kakao)
    private lazy var giftNoticeLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .caption
        label.textColor = .grey40
        label.text = AppInfo.giftPolicy
        label.setHeadIndent()
        label.numberOfLines = 0

        return label
    }()
    private lazy var giftInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.addArrangedSubviews([self.kakaoGiftButton, self.giftNoticeLabel])

        return stackView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: Init

    init(viewModel: GiftCompletionViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

}
