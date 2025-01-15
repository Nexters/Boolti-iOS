//
//  PopupShowView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/15/25.
//

enum PopupShowView {
    case home
    
    init?(rawValue: String) {
        switch rawValue {
        case "HOME":
            self = .home
        default:
            self = .home
        }
    }
}
