//
//  ImageCacheManager.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/29/24.
//

import UIKit

final class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
