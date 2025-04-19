//
//  WebviewCommand.swift
//  Boolti
//
//  Created by Juhyeon Byun on 4/19/25.
//

enum WebviewCommand {
    
    case showToast
    
    init?(rawValue: String) {
        switch rawValue {
        case "SHOW_TOAST":
            self = .showToast
        default:
            return nil
        }
    }

}
