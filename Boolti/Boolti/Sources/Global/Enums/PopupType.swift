//
//  PopupType.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/15/25.
//

enum PopupType {
    case event
    case notice
    
    init?(rawValue: String) {
        switch rawValue {
        case "EVENT":
            self = .event
        case "NOTICE":
            self = .notice
        default:
            self = .notice
        }
    }
}
