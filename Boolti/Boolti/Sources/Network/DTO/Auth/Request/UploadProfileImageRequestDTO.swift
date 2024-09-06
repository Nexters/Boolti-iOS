//
//  UploadProfileImageRequestDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/6/24.
//

import UIKit

struct UploadProfileImageRequestDTO {

    let uploadUrl: String
    let imageData: UIImage
    
    init(uploadUrl: String, image: UIImage) {
        self.uploadUrl = uploadUrl
        self.imageData = image
    }

}
