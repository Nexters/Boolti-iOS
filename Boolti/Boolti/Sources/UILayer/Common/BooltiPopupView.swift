//
//  BooltiPopupView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/19/24.
//

import UIKit

import RxSwift
import RxCocoa

// TODO: Close Button 있는 거까지 고려 및 모든 팝업 체크해서 재사용성 높게 변경하기

final class BooltiPopupView: UIView {
    
    // MARK: Properties
    
    enum PopupType {
        case networkError
        case refreshTokenHasExpired
        case accountRemoveCancelled
        case soldoutBeforePayment
        case ticketingFailed
        case requireLogin
        case registerGift
        case registerMyGift
        case registerGiftError
        case deleteLink
        case deleteSns
        case saveProfile
        case unknownProfile

        var title: String {
            switch self {
            case .networkError:
                "네트워크 오류가 발생했습니다\n잠시후 다시 시도해주세요"
            case .refreshTokenHasExpired:
                "로그인 세션이 만료되었습니다\n앱을 다시 시작해주세요"
            case .accountRemoveCancelled:
                "30일 내에 로그인하여\n계정 삭제가 취소되었어요.\n불티를 다시 찾아주셔서 감사해요!"
            case .soldoutBeforePayment, .ticketingFailed:
                "결제에 실패했어요"
            case .requireLogin:
                "로그인 후 선물 등록이 가능합니다.\n로그인해 주세요."
            case .registerGift:
                "선물을 등록하면\n선물 취소 및 환불이 불가합니다.\n등록하시겠습니까?"
            case .registerMyGift:
                "본인이 결제한 선물입니다.\n선물을 등록하면 다른 분께 보낼 수\n없습니다. 등록하시겠습니까?"
            case .registerGiftError:
                "선물 등록에 실패했어요"
            case .deleteLink:
                "링크를 삭제하시겠어요?"
            case .deleteSns:
                "SNS를 삭제하시겠어요?"
            case .saveProfile:
                "저장하지 않고 이 페이지를 나가면\n작성한 정보가 손실됩니다.\n변경된 정보를 저장할까요?"
            case .unknownProfile:
                "존재하지 않는 프로필입니다."
            }
        }
        
        var description: String? {
            switch self {
            case .soldoutBeforePayment, .ticketingFailed:
                "예매 진행 중 오류가 발생하였습니다.\n다시 시도해 주세요"
            case .registerGiftError:
                "선물 등록 중 오류가 발생했습니다.\n웹 링크에서 선물 상태를 확인 후\n다시 시도해 주세요"
            default:
                nil
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .soldoutBeforePayment, .ticketingFailed:
                "다시 예매하기"
            case .requireLogin:
                "로그인하기"
            case .registerGift, .registerMyGift:
                "등록하기"
            case .registerGiftError:
                "닫기"
            case .deleteLink, .deleteSns:
                "삭제하기"
            case .saveProfile:
                "저장하기"
            default:
                "확인"
            }
        }
        
        var cancelButtonTitle: String {
            switch self {
            case .saveProfile:
                "나가기"
            default:
                "취소하기"
            }
        }
        
        var withCloseButton: Bool {
            switch self {
            case .deleteLink, .deleteSns, .saveProfile:
                true
            default:
                false
            }
        }
    }
    
    let disposeBag = DisposeBag()
    var popupType: PopupType = .networkError
    
    // MARK: UI Component
    
    private let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black100.withAlphaComponent(0.85)
        return view
    }()
    
    private let popupBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey85
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead2
        label.numberOfLines = 0
        label.textColor = .grey15
        return label
    }()
    
    private let descriptionLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .body1
        label.numberOfLines = 0
        label.textColor = .grey50
        return label
    }()
    
    private let cancelButton: BooltiButton = {
        let button = BooltiButton(title: "취소하기")
        button.backgroundColor = .grey80
        button.isHidden = true
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)
        return button
    }()
    
    private let confirmButton = BooltiButton(title: "확인")
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        stackView.addArrangedSubviews([self.cancelButton, self.confirmButton])
        return stackView
    }()
    
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

extension BooltiPopupView {
    
    func showPopup(with type: PopupType,
                   withCancelButton: Bool = false) {
        self.titleLabel.text = type.title
        self.titleLabel.setAlignment(.center)
        self.descriptionLabel.text = type.description
        self.descriptionLabel.setAlignment(.center)
        self.confirmButton.setTitle(type.buttonTitle, for: .normal)
        
        self.cancelButton.isHidden = !withCancelButton
        
        if type.withCloseButton {
            self.cancelButton.setTitle(type.cancelButtonTitle, for: .normal)
            self.configureCloseButton()
        }
        
        self.popupType = type
        self.isHidden = false
    }
    
    func didCancelButtonTap() -> Signal<Void> {
        return self.cancelButton.rx.tap.asSignal()
    }
    
    func didConfirmButtonTap() -> Signal<Void> {
        return self.confirmButton.rx.tap.asSignal()
    }
    
    func didCloseButtonTap() -> Signal<Void> {
        return self.closeButton.rx.tap.asSignal()
    }
}

// MARK: - UI

extension BooltiPopupView {
    
    private func configureUI() {
        self.addSubviews([self.dimmedBackgroundView,
                          self.popupBackgroundView,
                          self.titleLabel,
                          self.descriptionLabel,
                          self.buttonStackView,
                         ])
        self.isHidden = true
    }
    
    private func configureCloseButton() {
        self.addSubview(self.closeButton)
        
        self.closeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.equalTo(self.popupBackgroundView).inset(12)
            make.right.equalTo(self.popupBackgroundView.snp.right).inset(20)
        }
        
        self.titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(self.closeButton.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(self.popupBackgroundView).inset(20)
        }
    }
    
    private func configureConstraints() {
        self.dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.popupBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.popupBackgroundView).offset(32)
            make.horizontalEdges.equalTo(self.popupBackgroundView).inset(20)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(self.titleLabel)
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(self.popupBackgroundView).inset(20)
        }
    }
}
