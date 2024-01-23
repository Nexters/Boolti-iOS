//
//  TicketViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation
import RxSwift
import RxRelay

enum TicketViewDestination {
    case login
}

final class TicketViewModel {

    private let authAPIService: AuthAPIServiceType

    let isLoading = PublishRelay<Bool>()
    let navigation = PublishRelay<TicketViewDestination>()
    let isAccessTokenLoaded = PublishRelay<Bool>()


    // TODO: 토큰 여부 확인 후 로그인 뷰로 이동

    init(authAPIService: AuthAPIServiceType) {
        self.authAPIService = authAPIService
    }

    func loadAccessToken() {
        print("여기 타냐?..")
        let token = authAPIService.fetchTokens()
        print("힝!..")

        guard token.accessToken != "" && token.refreshToken != "" else {
            
            self.isAccessTokenLoaded.accept(false)
            return
        }
        
        self.isAccessTokenLoaded.accept(true)
        // 만약 accessToken이 존재한다면? 그냥 화면 띄우기!..
    }

     func startLoading() {
         print("뭔데..")
        self.isLoading.accept(true)
    }
}
