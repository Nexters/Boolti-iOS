//
//  PosterExpandViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/24/24.
//

import Foundation

final class PosterExpandViewModel {
    
    // MARK: Properties
    
    let posters: [ConcertDetailEntity.Poster]
    
    // MARK: Init
    
    init(posters: [ConcertDetailEntity.Poster]) {
        self.posters = posters
    }
}
