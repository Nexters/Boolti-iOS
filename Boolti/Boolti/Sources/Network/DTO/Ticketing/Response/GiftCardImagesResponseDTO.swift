//
//  GiftCardImagesResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/23/24.
//

import Foundation

struct GiftCardImagesResponseDTOElement: Decodable {
    let id: Int
    let path: String
    let thumbnailPath: String
    let invite_path: String?
    let invite_thumbnail: String?
    let sequence: Int
    let createdAt: String
    let modifiedAt: String?
    let removedAt: String?
}

typealias GiftCardImagesResponseDTO = [GiftCardImagesResponseDTOElement]

extension GiftCardImagesResponseDTO {

    func convertToGiftCardImageEntities() -> [GiftCardImageEntity] {
        return self.map { image in
            return GiftCardImageEntity(id: image.id,
                                       path: image.path,
                                       thumbnailPath: image.thumbnailPath)
        }
    }
}
