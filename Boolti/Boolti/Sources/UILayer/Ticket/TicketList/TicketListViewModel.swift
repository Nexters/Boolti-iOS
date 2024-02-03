//
//  TicketViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources
import RxCocoa
import UIKit

enum TicketViewDestination {
    case login
}

final class TicketListViewModel {

    private let authAPIService: AuthAPIServiceType
    private let disposeBag = DisposeBag()

    // VC에서 일어나는 것
    struct Input {
        var viewDidAppearEvent = PublishSubject<Void>()
        var didloginButtonTapEvent = PublishSubject<Void>()
        var shouldLoadTableViewEvent = PublishSubject<Void>()
    }

    // Input에 의해서 생기는 ViewModel의 Output
    struct Output {
        let navigation = PublishRelay<TicketViewDestination>()
        let isAccessTokenLoaded = PublishRelay<Bool>()
        let isTicketsExist = PublishRelay<Bool>()
        let sectionModels: BehaviorRelay<[TicketItem]> = BehaviorRelay(value: [])
    }

    private let isAccessTokenExist = PublishRelay<Bool>()

    let input: Input
    let output: Output

    init(authAPIService: AuthAPIServiceType) {
        self.authAPIService = authAPIService
        
        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.bindViewDidAppearEvent()
        self.bindLoginButtonTapEvent()
        self.bindShouldLoadTableViewEvent()
    }

    private func bindViewDidAppearEvent() {
        self.input.viewDidAppearEvent
            .subscribe(with: self) { owner, _ in
                if owner.isAccessTokenAvailable() {
                    owner.output.isAccessTokenLoaded.accept(true)
                } else {
                    owner.output.isAccessTokenLoaded.accept(true)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func bindLoginButtonTapEvent() {
        self.input.didloginButtonTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                owner.output.navigation.accept(.login)
            })
            .disposed(by: self.disposeBag)
    }

    private func bindShouldLoadTableViewEvent() {
        self.input.shouldLoadTableViewEvent
            .flatMap { self.fetchTicketItemsByAPI() }
            .subscribe(with: self) { owner, ticketItems in
                if ticketItems.isEmpty {
                    owner.output.isTicketsExist.accept(false)
                } else {
                    owner.output.sectionModels.accept(ticketItems)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func isAccessTokenAvailable() -> Bool {
        let token = authAPIService.fetchTokens()
        let accessToken = token.0
        return (!accessToken.isEmpty)
    }

    private func fetchTicketItemsByAPI() -> Single<[TicketItem]> {
        // 만약 API 호출을 했는데, 빈 배열이 있으면 Ticket이 없는 것이고,
        // 아래와 같이 fetch가 되면, Ticket이 있다.
        // 현재는 있다고 가정!..
        let items: [TicketItem] = [
            TicketItem(ticketType: "일반 티켓 B", poster: .mockPoster, title: "2024 TOGETHER LUCKY CLUB", date: "2024.01.20 (토)", location: "클럽샤프", qrCode: .qrCode, number: 2),
            TicketItem(ticketType: "일반 티켓 B", poster: .mockPoster, title: "2024 TOGETHER LUCKY CLUB", date: "2024.01.20 (토)", location: "클럽샤프", qrCode: .qrCode, number: 2),
            TicketItem(ticketType: "일반 티켓 B", poster: .mockPoster, title: "2024 TOGETHER LUCKY CLUB ㄴㅇㄹㄴㅁㄹㅇㄴㄹㄴㄹㄴㄹ", date: "2024.01.20 (토)", location: "클럽샤프", qrCode: .qrCode, number: 2),
            TicketItem(ticketType: "일반 티켓 B", poster: .mockPoster, title: "2024 TOGETHER LUCKY CLUB", date: "2024.01.20 (토)", location: "클럽샤프", qrCode: .qrCode, number: 2),
            TicketItem(ticketType: "일반 티켓 B", poster: .mockPoster, title: "2024 TOGETHER LUCKY CLUB", date: "2024.01.20 (토)", location: "클럽샤프", qrCode: .qrCode, number: 2),
        ]
        return Single.just(items)
    }
}
