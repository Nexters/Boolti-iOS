//
//  RootViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

import RxSwift
import RxRelay

final class RootViewModel {

    private let disposeBag = DisposeBag()

    private let networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }

    let navigation = BehaviorRelay<RootDestination>(value: .splash)

    func registerDeviceToken() {
        let requestDTO = DeviceTokenRegisterRequestDTO(deviceToken: UserDefaults.deviceToken)
        let API = PushNotificationAPI.register(requestDTO: requestDTO)

        self.networkService.request(API)
            .map(DeviceTokenRegisterResponseDTO.self)
            .subscribe(with: self, onSuccess: { owner, response in
                print(response.tokenId)
            })
            .disposed(by: self.disposeBag)
    }
}

extension RootViewModel: SplashViewModelDelegate {

    func splashViewModel(_ didSplashViewControllerDismissed: SplashViewModel) {
        self.navigation.accept(.homeTab)
    }
}
