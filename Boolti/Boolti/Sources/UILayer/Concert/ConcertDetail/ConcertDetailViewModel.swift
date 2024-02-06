//
//  ConcertDetailViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import Foundation
import RxRelay
import RxSwift

final class ConcertDetailViewModel {
    
    // MARK: Properties
    
    enum ButtonState: String {
        case onSale = "예매하기"
        case beforeSale = "예매 시작 D-"
        case endSale = "예매 마감"
        case endConcert = "공연 종료"
    }
    
    struct Output {
        let concertDetail = BehaviorRelay<ConcertDetailEntity>(value: .init(id: 1, groupId: 1, name: "윤민이의 원맨쇼", placeName: "홍대 어딘가", date: Date(), runningTime: 150, streetAddress: "경기도 수원시 어딘가", detailAddress: "지하 2층", notice: "담배 ㄴㄴ\nThe Volunteers - Let me go!\n실리카겔 - No Pain\n데이먼스 이어 - Yours\n윤하 - 오르트구름 (Rock 편곡)\n체리필터 - 낭만고양이\nThe Volunteers - Let me go!\n실리카겔 - No Pain\n데이먼스 이어 - Yours\n윤하 - 오르트구름 (Rock 편곡)\n체리필터 - 낭만고양이\n윤하 - 오르트구름 (Rock 편곡)\n체리필터 - 낭만고양이\nThe Volunteers - Let me go!\n실리카겔 - No Pain\n데이먼스 이어 - Yours\n윤하 - 오르트구름 (Rock 편곡)\n체리필터 - 낭만고양이", salesStartTime: Date(), salesEndTime: Date().addingTimeInterval(12341234), showImg: [.init(id: 1, path: "https://dudoong.com/_next/image?url=https%3A%2F%2Fasset.dudoong.com%2Fproduction%2Fevent%2F153%2F14cc2eca-7c83-43ca-8ae4-85a7569f298e.png&w=640&q=75", thumbnailPath: "https://dudoong.com/_next/image?url=https%3A%2F%2Fasset.dudoong.com%2Fproduction%2Fevent%2F153%2F14cc2eca-7c83-43ca-8ae4-85a7569f298e.png&w=640&q=75", sequence: 1)]))
        let buttonState = BehaviorRelay<ButtonState>(value: .onSale)
    }
    
    let output: Output
    
    // MARK: Init
    
    init() {
        self.output = Output()
    }
}
