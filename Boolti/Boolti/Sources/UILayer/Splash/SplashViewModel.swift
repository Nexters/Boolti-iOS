//
//  SplashViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation
import RxRelay
import Firebase

final class SplashViewModel {
    
    private let authAPIservice: AuthAPIServiceType
    private let navigationDelegate: SplashViewModelDelegate

    let updateRequired = PublishRelay<Bool>()

    private let remoteConfig = RemoteConfig.remoteConfig()

    init(authAPIService: AuthAPIServiceType, delegate: SplashViewModelDelegate) {
        self.authAPIservice = authAPIService
        self.navigationDelegate = delegate
        self.initRemoteConfig()
    }
    
    func initRemoteConfig() {
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
        remoteConfig.setDefaults(fromPlist: "GoogleService-Info")
    }

    func navigateToHomeTab() {
        navigationDelegate.splashViewModel(self)
    }
    
    func checkUpdateRequired() {
        self.remoteConfig.fetchAndActivate(completionHandler: { status, error in
            if status == .error { return }
            
            guard let minVersion = self.remoteConfig.configValue(forKey: "MinVersion").stringValue else { return }
            let updateRequired = self.remoteConfig.configValue(forKey: "UpdateRequired").boolValue
            
            self.updateRequired.accept(updateRequired &&
                                       AppInfo.appVersion?.compare(minVersion, options: .numeric) == .orderedAscending)
        })
    }
}
