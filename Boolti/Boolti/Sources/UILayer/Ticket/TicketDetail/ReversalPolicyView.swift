//
//  ReversalPolicyView.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class ReversalPolicyView: UIStackView {

    private let disposeBag = DisposeBag()

    private let titleView: UIView = {
        let view = UIView()
//        view.backgroundColor = .black100
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "취소/환불 규정"
        label.font = .subhead2
        label.textColor = .grey10
        return label
    }()

    private let viewCollapseButton: UIButton = {
        let button = UIButton()
        button.setImage(.chevronDown, for: .normal)
        button.setImage(.chevronUp, for: .selected)
        return button
    }()

    private let reversalPolicyLabel: BooltiPaddingLabel = {
        let label = BooltiPaddingLabel(padding: UIEdgeInsets(top: 0, left: 20, bottom: 24, right: 20))
        label.text = "- 공연장 입장은 공연 30분 전부터 가능합니다. \n- 본 티켓은 타인에게 양도할 수 없습니다. \n- 입구에서 동봉한 티켓 이미지와 본인 확인이 가능한 신분증을 스태프에게 확인 후 입장 가능합니다. \n- 사전에 함께 구매하신 굿즈는 동봉한 교환증 이미지와 본인 확인이 가능한 신분증을 스태프에게 확인 후 수령 가능합니다. \n- 공연장 내 물품보관함이 별도로 존재하지 않으니 소지품을 최대한 간소화하여 오시기 바랍니다. \n- 공연장 내에서는 주류 반입이 금지되어 있습니다. 또한 캐리어 및 폭죽, 레이저와 같은 위험물질은 반입이 금지되어 있습니다."
        label.setLineSpacing(lineSpacing: 6)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .body1
        label.textColor = .grey50
        label.isHidden = true

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.configureUI()
        self.bindUIComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.axis = .vertical
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grey50.cgColor

        self.titleView.addSubviews([
            self.titleLabel, self.viewCollapseButton
        ])

        self.addArrangedSubviews([
            self.titleView,
            self.reversalPolicyLabel
        ])

        self.snp.makeConstraints { make in
            make.width.equalTo(317)
        }

        self.titleView.snp.makeConstraints { make in
            make.height.equalTo(66)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }

        self.viewCollapseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }

        self.reversalPolicyLabel.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }

    private func bindUIComponents() {
        self.viewCollapseButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewCollapseButton.isSelected.toggle()

                UIView.animate(withDuration: 0.3) {
                    owner.reversalPolicyLabel.isHidden.toggle()
                    owner.layoutIfNeeded()
                }
            }
            .disposed(by: self.disposeBag)
    }

}
