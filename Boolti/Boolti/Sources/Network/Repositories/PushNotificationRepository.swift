//
//  PushNotificationRepository.swift
//  Boolti
//
//  Created by Miro on 2/27/24.
//

import Foundation

import FirebaseMessaging
import RxSwift

protocol PushNotificationRepositoryType {

    var networkService: NetworkProviderType { get }
    func registerDeviceToken()
}

final class PushNotificationRepository: PushNotificationRepositoryType {

    var networkService: NetworkProviderType
    private let disposeBag = DisposeBag()

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }

    func registerDeviceToken() {
        Messaging.messaging().token { token, error in
            if let error {
                print(error)
            }
            guard let token else { return }
            guard UserDefaults.accessToken != "" else { return } // 만약 로그인을 안한 유저라면, API를 호출하지 않는다.

            let requestDTO = DeviceTokenRegisterRequestDTO(deviceToken: token)
            let API = PushNotificationAPI.register(requestDTO: requestDTO)

            self.networkService.request(API)
                .map(DeviceTokenRegisterResponseDTO.self)
                .subscribe(with: self, onSuccess: { owner, response in
                    print(response.tokenId)
                })
                .disposed(by: self.disposeBag)
        }
    }
}
