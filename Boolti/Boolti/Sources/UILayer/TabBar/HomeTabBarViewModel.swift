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
    let popToRootViewController = PublishRelay<HomeTab>()
    let dynamicLinkDestination = PublishRelay<BooltiViewController.Type>()

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
        // 요것도 파라미터로 받아서 ConcertDetail을 넣을 수 있도록 하기
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(navigateToConcertDetail),
            name: Notification.Name.DynamicDestination.concertDetail,
            object: nil
        )
    }

    @objc func changeTabBarSelectedIndex(_ notification:Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let index = userInfo["tabBarIndex"] as? Int else { return }
        guard let selectedTab = HomeTab(rawValue: index) else { return }

        // 현재 탭에서 싹다 pop하기
        self.popToRootViewController.accept(self.currentTab.value)
        // 새로운 탭으로 옮기기
        self.selectTab(index: index)
        // 요거 나누기!.. pop하는 거랑 navigate 하는거랑...!
//        self.popToRootViewController.accept(selectedTab)
    }

    @objc func navigateToConcertDetail() {
        self.dynamicLinkDestination.accept(ConcertListViewController.self)
    }
}
