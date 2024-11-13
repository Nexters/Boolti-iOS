//
//  PerformedConcertListViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/12/24.
//

final class PerformedConcertListViewModel {
    
    // MARK: Properties
    
    let concertList: [PerformedConcertEntity]
    
    // MARK: Initailizer
    
    init(concertList: [PerformedConcertEntity]) {
        self.concertList = concertList
    }
    
}
