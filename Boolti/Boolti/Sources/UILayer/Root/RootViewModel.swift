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
    
    let navigation = BehaviorRelay<RootDestination>(value: .splash)
}

extension RootViewModel: SplashViewViewModelDelegate {

    func splashViewViewModel(_ didSplashViewControllerDismissed: SplashViewModel) {
        self.navigation.accept(.homeTab)
    }
}
