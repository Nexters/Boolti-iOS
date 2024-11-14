//
//  SNSType.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/13/24.
//

enum SNSType: String, Codable {
    case instagram = "Instagram"
    case youtube = "YouTube"
    
    init?(_ rawValue: String){
        switch rawValue {
        case "Instagram":
            self  = .instagram
        case "YouTube":
            self = .youtube
        default:
            return nil
        }
    }
}
