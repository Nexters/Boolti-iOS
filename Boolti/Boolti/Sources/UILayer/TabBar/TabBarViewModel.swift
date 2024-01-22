//
//  TabBarViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation
import RxSwift
import RxRelay

final class TabBarViewModel {

    let tabItems = BehaviorRelay<[HomeTab]>(value: HomeTab.allCases)
    let currentTab = PublishRelay<HomeTab>()

    func selectTab(index: Int) {
        guard let selectedTab = HomeTab(rawValue: index) else { return }
        currentTab.accept(selectedTab)
    }
}
