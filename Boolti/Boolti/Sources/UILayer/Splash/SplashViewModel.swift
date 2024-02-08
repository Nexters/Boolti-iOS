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
    
    private let authRepository: AuthRepositoryType
    private let navigationDelegate: SplashViewModelDelegate

    private let remoteConfig = RemoteConfig.remoteConfig()
    
    struct Output {
        let updateRequired = PublishRelay<Bool>()
    }
    
    let output: Output
    
    init(authRepository: AuthRepositoryType, delegate: SplashViewModelDelegate) {
        self.output = Output()
        
        self.authRepository = authRepository
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
            
            self.output.updateRequired.accept(updateRequired &&
                                       AppInfo.appVersion?.compare(minVersion, options: .numeric) == .orderedAscending)
        })
    }
}
