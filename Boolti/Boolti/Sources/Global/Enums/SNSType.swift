//
//  SNSType.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/13/24.
//

import UIKit

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
    
    var urlPath: String {
        switch self {
        case .instagram:
            return "https://www.instagram.com/"
        case .youtube:
            return "https://www.youtube.com/@"
        }
    }
    
    var image: UIImage {
        switch self {
        case .instagram:
            return .instagram
        case .youtube:
            return .youtube
        }
    }
    
    var description: String {
        switch self {
        case .instagram:
            return "instagram"
        case .youtube:
            return "youtube"
        }
    }
}
