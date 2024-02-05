//
//  ConcertDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ConcertDetailViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: ConcertDetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationView = BooltiNavigationView(type: .concertDetail)

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubviews([self.stackView])
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        stackView.addArrangedSubviews([self.concertPosterView,
                                       self.ticketingPeriodView,
                                       self.datetimeInfoView,
                                       self.placeInfoView,
                                       self.contentInfoView,
                                       self.organizerInfoView])
        
        stackView.setCustomSpacing(40, after: self.concertPosterView)
        return stackView
    }()
    
    private let concertPosterView = ConcertPosterView()
    
    private let ticketingPeriodView = TicketingPeriodView()
    
    private let datetimeInfoView = DatetimeInfoView()
    
    private let placeInfoView = PlaceInfoView()
    
    private let contentInfoView = ContentInfoView()
    
    private let organizerInfoView = OrganizerInfoView()
    
    private let button = BooltiButton(title: "예매하기")
    
    // MARK: Init
    
    init(viewModel: ConcertDetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .grey95
        
        self.configureUI()
        self.configureConstraints()
        self.configureToastView(isButtonExisted: true)
        self.bindPlaceInfoView()
        self.bindNavigationView()
        
        // 확인용
        self.concertPosterView.setData(images: [.mockPoster, .mockPoster, .mockPoster], title: "2024 TOGETHER LUCKY CLUB")
        self.ticketingPeriodView.setData(startDate: Date(), endDate: Date().addingTimeInterval(1234541))
        self.placeInfoView.setData(name: "클럽 샤프", address: "서울특별시 마포구 와우산로 19길 20 / 지하 1층")
        self.datetimeInfoView.setData(datetime: "2024.01.20 (토) / 18:00 (150분)")
        self.contentInfoView.setData(content: "[팀명 및 팀 소개]\nOvO (오보)\n웃는 표정, 틀려도 웃고 넘기자!\n[팀명 및 팀 소개]\nOvO (오보)\n웃는 표정, 틀려도 웃고 넘기자!\n[팀명 및 팀 소개]\nOvO (오보)\n웃는 표정, 틀려도 웃고 넘기자!\n[팀명 및 팀 소개]\nOvO (오보)\n웃는 표정, 틀려도 웃고 넘기자!\n[팀명 및 팀 소개]\nOvO (오보)\n웃는 표정, 틀려도 웃고 넘기자!\n[팀명 및 팀 소개]\nOvO (오보)\n웃는 표정, 틀려도 웃고 넘기자!")
        self.organizerInfoView.setData(organizer: "박불티 (010-1234-5678)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Methods

extension ConcertDetailViewController {
    
    private func bindPlaceInfoView() {
        self.placeInfoView.didAddressCopyButtonTap()
            .emit(with: self) { owner, _ in
                UIPasteboard.general.string = self.placeInfoView.addressLabel.text
                owner.showToast(message: "공연장 주소가 복사되었어요")
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindNavigationView() {
        self.navigationView.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationView.didHomeButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationView.didShareButtonTap()
            .emit(with: self) { owner, _ in
                
                // TODO: 공유하기 내용 수정
                let activityViewController = UIActivityViewController(activityItems: [UIImage.mockPoster, "2024 TOGETHER LUCKY CLUB"], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = owner.view
                owner.present(activityViewController, animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationView.didMoreButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension ConcertDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationView,
                               self.scrollView,
                               self.button])
    }
    
    private func configureConstraints() {
        self.navigationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.button.snp.top)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalTo(self.scrollView)
        }
        
        self.button.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
