//
//  TicketEntryCodeViewModel.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import Foundation

import RxSwift
import RxMoya
import RxRelay

class TicketEntryCodeViewModel {

    struct Input {
        var didCheckButtonTapEvent = PublishSubject<String>()
    }

    struct Output {
        let isValidEntryCode = PublishRelay<Bool>()
    }

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()
    private let networkService: NetworkProviderType

    private let ticketID: String
    private let concertID: String

    init(ticketID: String, concertID: String, networkService: NetworkProviderType) {
        self.ticketID = ticketID
        self.concertID = concertID
        self.networkService = networkService

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.didCheckButtonTapEvent
            .flatMap { self.validateEntryCode(entryCode: $0) }
            .subscribe(with: self) { owner, isValid in
                owner.output.isValidEntryCode.accept(isValid)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func validateEntryCode(entryCode: String) -> Observable<Bool> {
        let requestDTO = TicketEntryCodeRequestDTO(ticketID: self.ticketID, concertID: self.concertID, entryCode: entryCode)

        let api = TicketAPI.entryCode(requestDTO: requestDTO)
        return Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            self.networkService.request(api)
                .filterSuccessfulStatusCodes()
                .subscribe { _ in
                    observer.onNext(true)
                    observer.onCompleted()
                } onFailure: { _ in
                    observer.onNext(false)
                    observer.onCompleted()
                }
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}
