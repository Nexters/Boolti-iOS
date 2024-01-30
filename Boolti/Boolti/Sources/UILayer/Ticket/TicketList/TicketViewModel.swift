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

enum TicketViewDestination {
    case login
}

final class TicketViewModel {

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
        let sectionModels: BehaviorRelay<[TicketSection]> = BehaviorRelay(value: [])
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
                    // 서버와의 통신!..
                    // 그리고 sectionModel로 보내기!..
                    owner.output.isAccessTokenLoaded.accept(true)
                } else {
                    owner.output.isAccessTokenLoaded.accept(false)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func bindLoginButtonTapEvent() {
        // 로그인 버튼을 누르면 로그인 화면으로 넘어가기
        self.input.didloginButtonTapEvent
            .subscribe(with: self, onNext: { owner, _ in
                owner.output.navigation.accept(.login)
            })
            .disposed(by: self.disposeBag)
    }

    private func bindShouldLoadTableViewEvent() {
        self.input.shouldLoadTableViewEvent
            .flatMap { self.fetchTableViewSectionByAPI() }
            .subscribe(with: self) { owner, ticketSections in
                // 만약 ticketSections가 0이면 홈 탭으로 옮기는 homeEnterView를 던져야된다.
                if ticketSections.isEmpty {
                    owner.output.isTicketsExist.accept(false)
                } else {
//                    owner.output.isTicketsExist.accept(false)
                    owner.output.sectionModels.accept(ticketSections)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func isAccessTokenAvailable() -> Bool {
        // accessToken이 있으면 output으로 넘기기!..
        let token = authAPIService.fetchTokens()
        return (!token.accessToken.isEmpty)
    }

    private func fetchTableViewSectionByAPI() -> Single<[TicketSection]> {
        // 만약 API 호출을 했는데, 빈 배열이 있으면 Ticket이 없는 것이고,
        // 아래와 같이 fetch가 되면, Ticket이 있다.
        // 현재는 있다고 가정!..
        let sections: [TicketSection] = [
            .confirmingDeposit(items: [
                .confirmingDepositTicket(id: 1, title: "안녕하세요"),
                .confirmingDepositTicket(id: 1, title: "안녕하세요.sdfsfsfsfsffs")
            ]),
            .usable(items: [
                .usableTicket(item: UsableTicket(ticketType: .premium, poster: .mockPoster, title: "2024 TOGETHER LUCKY CLUB sㄴㅇㄹㅇfdㄴㄹㄴfdfsdfdsfsfsfsfsfssffsdfsdsfd", date: "2024.01.20 (토)", location: "클럽샤프", qrCode: .qrCode, number: 1)),
                .usableTicket(item: UsableTicket(ticketType: .premium, poster: .mockPoster, title: "2024 TOGETHER LUCKY CLUB", date: "2024.01.20 (토)", location: "클럽샤프", qrCode: .qrCode, number: 1)),
            ]),
            .used(items: [
                .usedTicket(item: UsedTicket(ticketType: .invitation, poster: .mockPoster, title: "HEXA 3rd Concert", date: "2024.01.20", location: "클럽샤프", number: 1)),
                .usedTicket(item: UsedTicket(ticketType: .invitation, poster: .mockPoster, title: "HEXA 3rd Concert", date: "2024.01.20", location: "클럽샤프", number: 11))
            ])
        ]
        return Single.just(sections)
    }
}
