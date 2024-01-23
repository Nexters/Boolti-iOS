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

extension RootViewModel: SplashViewModelDelegate {
    func splashViewModel(_ didSplashViewControllerDismissed: SplashViewModel, with token: Token) {
        self.navigation.accept(.homeTab(token))
    }

}
