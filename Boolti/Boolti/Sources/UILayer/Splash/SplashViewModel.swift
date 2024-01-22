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

    init(authAPIService: AuthAPIServiceType, delegate: SplashViewModelDelegate) {
        self.authAPIservice = authAPIService
        self.navigationDelegate = delegate
    }

    func navigateToHomeTab() {
        navigationDelegate.splashViewModel(self)
    }
    
    func checkUpdateRequired() {
        let remoteConfig = RemoteConfig.remoteConfig()
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
        remoteConfig.setDefaults(fromPlist: "GoogleService-Info")
        
        remoteConfig.fetchAndActivate(completionHandler: { status, error in
            if status == .error { return }
            
            guard let minVersion = remoteConfig.configValue(forKey: "MinVersion").stringValue else { return }
            let updateRequired = remoteConfig.configValue(forKey: "UpdateRequired").boolValue
            
            self.updateRequired.accept(updateRequired &&
                                       AppInfo.appVersion?.compare(minVersion, options: .numeric) == .orderedAscending)
        })
    }
}
