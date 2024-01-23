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

    let isLoading = PublishRelay<Bool>()

    // TODO: 토큰 여부 확인 후 로그인 뷰로 이동

    init() {

    }

     func startLoading() {
         print("뭔데..")
        self.isLoading.accept(true)
    }
}
