//
//  AddLinkHeaderView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/5/24.
//

import UIKit

import RxSwift

final class AddLinkHeaderView: UICollectionReusableView {
    
    // MARK: Properties
    
    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    
    private let addLinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .addCircle
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .subhead1
        label.textColor = .grey15
        label.text = "링크 추가"
        return label
    }()
    
    // MARK: Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
}

// MARK: - UI

extension AddLinkHeaderView {
    
    private func configureUI() {
        self.addSubviews([self.addLinkImageView,
                          self.titleLabel])
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.addLinkImageView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
        }

        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.addLinkImageView.snp.trailing).offset(16)
        }
    }
    
}
