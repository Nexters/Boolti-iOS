//
//  PopupShowView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/15/25.
//

enum PopupShowView: String {
    case home = "HOME"
    case concert = "SHOW"
    
    init?(rawValue: String) {
        switch rawValue {
        case "HOME":
            self = .home
        case "SHOW":
            self = .concert
        default:
            self = .home
        }
    }
}
