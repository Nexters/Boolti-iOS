//
//  PerformedConcertListViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/12/24.
//

final class PerformedConcertListViewModel {
    
    // MARK: Properties
    
    let concertList: [ConcertEntity]
    
    // MARK: Initailizer
    
    init(concertList: [ConcertEntity]) {
        self.concertList = concertList
    }
    
}
