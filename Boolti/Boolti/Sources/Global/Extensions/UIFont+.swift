//
//  UIFont+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/24/24.
//

import UIKit.UIFont

extension UIFont {
    
    static func pretendardB(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size)!
    }
    
    static func pretendardR(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size)!
    }
    
    static func aggroB(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OTSBAggroB", size: size)!
    }
    
    static func aggroM(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OTSBAggroM", size: size)!
    }
    
    class var headline3: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 28.0)!
    }
    
    class var headline2: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 24.0)!
    }
    
    class var headline1: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 20.0)!
    }
    
    class var subhead2: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 18.0)!
    }
    
    class var subhead1: UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: 16.0)!
    }
    
    class var body4: UIFont {
        return UIFont(name: "Pretendard-Regular", size: 18.0)!
    }
    
    class var body3: UIFont {
        return UIFont(name: "Pretendard-Regular", size: 16.0)!
    }
    
    class var body2: UIFont {
        return UIFont(name: "Pretendard-Regular", size: 15.0)!
    }
    
    class var body1: UIFont {
        return UIFont(name: "Pretendard-Regular", size: 14.0)!
    }
    
    class var caption: UIFont {
        return UIFont(name: "Pretendard-Regular", size: 12.0)!
    }
    
    class var point4: UIFont {
        return UIFont(name: "OTSBAggroM", size: 24.0)!
    }
    
    class var point3: UIFont {
        return UIFont(name: "OTSBAggroB", size: 24.0)!
    }
    
    class var point2: UIFont {
        return UIFont(name: "OTSBAggroB", size: 20.0)!
    }
    
    class var point1: UIFont {
        return UIFont(name: "OTSBAggroB", size: 16.0)!
    }
}
