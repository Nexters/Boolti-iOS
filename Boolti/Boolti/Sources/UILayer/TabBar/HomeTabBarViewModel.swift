//
//  TabBarViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

import RxSwift
import RxRelay

final class HomeTabBarViewModel {

    init() {
        self.configureNotificationCenter()
        self.configureCurrentTab()
    }

    let tabItems = BehaviorRelay<[HomeTab]>(value: HomeTab.allCases)
    let currentTab = BehaviorRelay<HomeTab>(value: .concert)

    func selectTab(index: Int) {
        guard let selectedTab = HomeTab(rawValue: index) else { return }
        self.currentTab.accept(selectedTab)
    }

    private func configureCurrentTab() {
        guard let selectedTab = HomeTab(rawValue: UserDefaults.tabBarIndex) else { return }
        self.currentTab.accept(selectedTab)
    }

    private func configureNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeTabBarSelectedIndex(_:)),
            name: Notification.Name.didTabBarSelectedIndexChanged,
            object: nil
        )
    }

    @objc func changeTabBarSelectedIndex(_ notification:Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let index = userInfo["tabBarIndex"] as? Int else { return }
        guard let selectedTab = HomeTab(rawValue: index) else { return }

        self.currentTab.accept(selectedTab)
    }
}
