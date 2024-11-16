//
//  SNSType.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/13/24.
//

import UIKit

enum SNSType: String, Codable, CaseIterable {
    case instagram = "INSTAGRAM"
    case youtube = "YOUTUBE"
    
    init?(_ rawValue: String){
        switch rawValue {
        case "INSTAGRAM":
            self  = .instagram
        case "YOUTUBE":
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
    
    var index: Int {
        switch self {
        case .instagram:
            return 0
        case .youtube:
            return 1
        }
    }
    
    var pattern: String {
        switch self {
        case .instagram:
            return "^[A-Za-z0-9._가-힣]+$"
        case .youtube:
            return "^[A-Za-z0-9._\\-가-힣]+$"
        }
    }

}
