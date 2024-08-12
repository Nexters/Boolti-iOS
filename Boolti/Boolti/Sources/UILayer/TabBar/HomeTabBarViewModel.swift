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
    let initialLandingTab = PublishRelay<HomeTab>() // Landing이 시작되는 처음 진입점

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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(navigateToConcertList),
            name: Notification.Name.LandingDestination.concertList,
            object: nil
        )

        // 요것도 파라미터로 받아서 ConcertDetail을 넣을 수 있도록 하기
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(navigateToConcertDetail),
            name: Notification.Name.LandingDestination.concertDetail,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(navigateToReservationList),
            name: Notification.Name.LandingDestination.reservationList,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(navigateToReservationDetail),
            name: Notification.Name.LandingDestination.reservationDetail,
            object: nil
        )
    }

    @objc func changeTabBarSelectedIndex(_ notification:Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let index = userInfo["tabBarIndex"] as? Int else { return }

        // 현재 탭에서 싹다 pop하기
        self.popToRootViewController.accept(self.currentTab.value)
        // 새로운 탭으로 옮기기
        self.selectTab(index: index)
    }

    @objc func navigateToConcertList() {
        self.initialLandingTab.accept(HomeTab.concert)
    }
    
    @objc func navigateToConcertDetail() {
        self.initialLandingTab.accept(HomeTab.concert)
    }

    @objc func navigateToReservationList() {
        self.initialLandingTab.accept(HomeTab.myPage)
    }

    @objc func navigateToReservationDetail() {
        self.initialLandingTab.accept(HomeTab.myPage)
    }
}
