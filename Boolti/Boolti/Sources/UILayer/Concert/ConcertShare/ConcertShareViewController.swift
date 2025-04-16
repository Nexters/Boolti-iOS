//
//  ConcertShareViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/3/25.
//

import UIKit

import RxSwift

final class ConcertShareViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let buttonBackgroundView = UIView()

    private let urlShareButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0)
        config.title = "URL만 공유하기"
        config.attributedTitle?.font = .body3
        config.baseForegroundColor = .grey10
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private let infoShareButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0)
        config.title = "공연 정보 함께 공유하기"
        config.attributedTitle?.font = .body3
        config.baseForegroundColor = .grey10
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    // MARK: Initailizer
    
    init(concertData: ConcertDetailEntity) {
        super.init()
        
        self.bindInputs(with: concertData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
}

// MARK: - Methods

extension ConcertShareViewController {
    
    private func bindInputs(with concertDetail: ConcertDetailEntity) {
        self.urlShareButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                let url = "\(Environment.PREVIEW_URL_PREFIX)/\(concertDetail.id)"

                let activityViewController = UIActivityViewController(
                    activityItems: [url],
                    applicationActivities: nil
                )
                activityViewController.popoverPresentationController?.sourceView = owner.view
                owner.present(activityViewController, animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
        
        self.infoShareButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                let concertInfo = concertDetail.convertToShareConcertString()

                let activityViewController = UIActivityViewController(
                    activityItems: [concertInfo],
                    applicationActivities: nil
                )
                activityViewController.popoverPresentationController?.sourceView = owner.view
                owner.present(activityViewController, animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UI

extension ConcertShareViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey85
        self.view.addSubviews([self.urlShareButton,
                               self.infoShareButton])
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.custom { _ in return 184}]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.urlShareButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(58)
        }
        
        self.infoShareButton.snp.makeConstraints { make in
            make.top.equalTo(self.urlShareButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(58)
        }
    }
    
}
