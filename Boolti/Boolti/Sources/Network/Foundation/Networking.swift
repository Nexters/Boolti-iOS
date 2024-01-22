//
//  Networking.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import RxSwift
import Moya

protocol Networking {
    func request(_ api: BaseAPI) -> Single<Response>
}
