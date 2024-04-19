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
        #if DEBUG
        setting.minimumFetchInterval = 0
        #endif
        remoteConfig.configSettings = setting
        remoteConfig.setDefaults(fromPlist: "GoogleService-Info") // 없어도 되지 않나?
    }

    func navigateToHomeTab() {
        navigationDelegate.splashViewModel(self)
    }
    
    func checkRemoteConfig() {
        self.remoteConfig.fetchAndActivate(completionHandler: { status, error in
            if status == .error { return }
            
            guard let minVersion = self.remoteConfig.configValue(forKey: "MinVersion").stringValue else { return }
            let updateRequired = self.remoteConfig.configValue(forKey: "UpdateRequired").boolValue
            let jsonReversalPolicy = self.remoteConfig.configValue(forKey: "RefundPolicy").jsonValue
            self.configureReversalPolicy(jsonStatements: jsonReversalPolicy)

            self.output.updateRequired.accept(updateRequired &&
                                       AppInfo.appVersion?.compare(minVersion, options: .numeric) == .orderedAscending)
        })
    }

    private func configureReversalPolicy(jsonStatements: Any?) {
        guard let revesalPolicyStatements = jsonStatements as? [String] else { return }
        let bulletAddedStatements = revesalPolicyStatements.map { "• \($0)" }
        let reversalPolicy = bulletAddedStatements.joined(separator: "\n")
        AppInfo.reversalPolicy = reversalPolicy
    }
}
