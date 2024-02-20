//
//  TicketEntryCodeViewModel.swift
//  Boolti
//
//  Created by Miro on 2/5/24.
//

import Foundation

import Moya
import RxSwift
import RxMoya
import RxRelay

final class TicketEntryCodeViewModel {

    struct Input {
        var didCheckButtonTapEvent = PublishSubject<String>()
    }

    struct Output {
        let entryCodeResponse = PublishRelay<EntryCodeResponse>()
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
            .subscribe(with: self) { owner, response in
                owner.output.entryCodeResponse.accept(response)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func validateEntryCode(entryCode: String) -> Observable<EntryCodeResponse> {
        let requestDTO = TicketEntryCodeRequestDTO(ticketID: self.ticketID, concertID: self.concertID, entryCode: entryCode)

        let api = TicketAPI.entryCode(requestDTO: requestDTO)
        return Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            self.networkService.request(api)
                .subscribe(with: self, onSuccess: { owner, response in
                    observer.onNext(EntryCodeResponse.valid)
                    observer.onCompleted()
                }, onFailure: { owner, error in
                    guard let error = error as? MoyaError else { return }
                    guard let response = error.response else { return }
                    let decodedData = try! JSONDecoder().decode(EntryCodeErrorResponseDTO.self, from: response.data)
                    let entryCodeResponseEntity = decodedData.convertToEntryCodeErrorResponseEntity()
                    observer.onNext(entryCodeResponseEntity.type)
                    observer.onCompleted()
                })
                .disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}


enum EntryCodeResponse {
    case valid
    case notToday
    case mismatch

    var description: String {
        switch self {
        case .valid:
            return "사용되었어요"
        case .notToday:
            return "아직 공연일이 아니에요"
        case .mismatch:
            return "올바른 입장 코드를 입력해 주세요"
        }
    }
}
