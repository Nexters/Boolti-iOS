//
//  TicketViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation
import RxSwift
import RxRelay

final class TicketViewModel {

    private let authAPIService: AuthAPIServiceType

    let isLoading = PublishRelay<Bool>()

    // TODO: 토큰 여부 확인 후 로그인 뷰로 이동

    init(authAPIService: AuthAPIServiceType) {
        self.authAPIService = authAPIService
    }

     func startLoading() {
        self.isLoading.accept(true)
    }

    func loadAccessToken() {
        let token = self.authAPIService.fetchTokens()
        
        // TODO: UserDefaults -> nil로 리팩토링 해야될 듯!..
//        guard token.0 != "" && token.1 != "" else {
//            // 이러면 로그인 페이지를 띄운다.
//            return
//        }

        
    }
}
