//
//  SelectTicketViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import Foundation
import RxSwift
import RxRelay

final class SelectTicketViewModel {
    
//    private let ticketAPIService: TicketAPIServiceType
    
    private let disposeBag = DisposeBag()
    
    struct Input {
    }

    struct Output {
        // TODO: 데이터 체크용. api 연결후 []로 초기화 예정
        let tickets = BehaviorRelay<[TicketEntity]>(value: [.init(id: 0, name: "초청 티켓", price: 0, inventory: 100),
                                                            .init(id: 1, name: "일반 티켓 A", price: 3000, inventory: 0),
                                                            .init(id: 2, name: "일반 티켓 B", price: 5000, inventory: 300)])
    }

    let input: Input
    let output: Output

//    init(ticketAPIService: TicketAPIService) {
//        self.ticketAPIService = ticketAPIService
    init() {
        self.input = Input()
        self.output = Output()
    }
}
