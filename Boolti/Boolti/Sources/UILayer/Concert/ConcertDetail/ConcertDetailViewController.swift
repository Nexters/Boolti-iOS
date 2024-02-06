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
    
    private lazy var buttonBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 16))
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.grey95.cgColor]
        view.layer.insertSublayer(gradient, at: 0)

        return view
    }()
    
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
        self.bindOutputs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Methods

extension ConcertDetailViewController {
    
    private func bindOutputs() {
        self.viewModel.output.concertDetail
            .take(1)
            .bind(with: self) { owner, entity in
                owner.concertPosterView.setData(images: [.mockPoster, .mockPoster, .mockPoster], title: entity.name)
                owner.ticketingPeriodView.setData(startDate: entity.salesStartTime, endDate: entity.salesEndTime)
                owner.placeInfoView.setData(name: entity.placeName, streetAddress: entity.streetAddress, detailAddress: entity.detailAddress)
                owner.datetimeInfoView.setData(date: entity.date, runningTime: entity.runningTime)
                owner.contentInfoView.setData(content: entity.notice)
                owner.organizerInfoView.setData(organizer: "박불티 (010-1234-5678)")
            }
            .disposed(by: self.disposeBag)
                
    }
    
    private func bindPlaceInfoView() {
        self.placeInfoView.didAddressCopyButtonTap()
            .emit(with: self) { owner, _ in
                UIPasteboard.general.string = self.viewModel.output.concertDetail.value.streetAddress
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
                               self.buttonBackgroundView,
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
        
        self.buttonBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(self.button.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(16)
        }
        
        self.button.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
