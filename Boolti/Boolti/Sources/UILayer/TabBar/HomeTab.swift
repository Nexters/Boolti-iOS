//
//  HomeTab.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

enum HomeTab: Int, CaseIterable {
    case concert
    case ticket
    case myPage
}

extension HomeTab: CustomStringConvertible {
    var description: String {
        switch self {
        case .concert: return "공연 리스트"
        case .ticket: return "티켓 내역"
        case .myPage: return "마이 페이지"
        }
    }
}

extension HomeTab {

    var icon: UIImage? {
        switch self {
        case .concert: return UIImage(named: "공연 리스트")
        case .ticket: return UIImage(named: "티켓 내역")
        case .myPage: return UIImage(named: "마이 페이지")
        }
    }

    var tag: Int {
        switch self {
        case .concert: return 0
        case .ticket: return 1
        case .myPage: return 2
        }
    }
}

extension HomeTab {
    func asTabBarItem() -> UITabBarItem {
        return UITabBarItem(
            title: description,
            image: icon,
            tag: tag
        )
    }
}
