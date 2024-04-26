//
//  TicketReservationDetailEntity.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

enum PaymentMethod: String {

    case accountTransfer = "ACCOUNT_TRANSFER"
    case card = "CARD"
    case free = "FREE"
    case simplePayment = "SIMPLE_PAYMENT"

    var description: String {
        switch self {
        case .accountTransfer: "계좌 이체"
        case .card: "카드 결제"
        case .free: "0원 티켓"
        case .simplePayment: "간편 결제"
        }
    }
}

struct PaymentCardDetail {
    let installmentPlanMonths: String
    let issuer: String
}

let cardTypeByCode = [
    "3K": "기업비씨",
    "46": "광주",
    "71": "롯데",
    "30": "산업",
    "31": "BC카드",
    "51": "삼성",
    "38": "새마을",
    "41": "신한",
    "62": "신협",
    "36": "씨티",
    "33": "우리",
    "W1": "우리",
    "37": "우체국",
    "39": "저축",
    "35": "전북",
    "42": "제주",
    "15": "카카오뱅크",
    "3A": "케이뱅크",
    "24": "토스뱅크",
    "21": "하나",
    "61": "현대",
    "11": "국민",
    "91": "농협",
    "34": "수협",
    "6D": "다이너스",
    "4M": "마스터",
    "3C": "유니온페이",
    "7A": "아메리칸 익스프레스",
    "4J": "JCB",
    "4V": "비자",
    "261": "교보증권",
    "12": "단위농협",
    "267": "대신증권",
    "287": "메리츠증권",
    "238": "미래에셋증권",
    "290": "부국",
    "32": "부산",
    "240": "삼성증권",
    "45": "새마을",
    "64": "산림",
    "291": "신영증권",
    "278": "신한금융투자",
    "88": "신한",
    "48": "신협",
    "27": "씨티",
    "20": "우리",
    "209": "유안타증권",
    "280": "유진투자증권",
    "50": "저축",
    "90": "카카오",
    "288": "카카오페이증권",
    "89": "케이",
    "264": "키움증권",
    "92": "토스",
    "271": "토스증권",
    "294": "펀드온라인코리아",
    "270": "하나금융투자",
    "81": "하나",
    "262": "하이투자증권",
    "243": "한국투자증권",
    "269": "한화투자증권",
    "263": "현대차증권",
    "54": "홍콩상하이은행",
    "279": "DB금융투자",
    "3": "기업",
    "4": "국민",
    "218": "KB증권",
    "2": "산업",
    "227": "KTB투자증권",
    "292": "LIG투자",
    "247": "NH투자증권",
    "23": "SC제일",
    "7": "수협",
    "266": "SK증권"
]

struct TicketReservationDetailEntity {

    let reservationID: String
    let concertPosterImageURLPath: String
    let concertTitle: String
    let salesTicketName: String
    let ticketType: TicketType
    let ticketCount: String
    let depositDeadLine: String
    let paymentMethod: PaymentMethod?
    let totalPaymentAmount: String
    let reservationStatus: ReservationStatus
    let ticketingDate: String?
    let purchaseName: String
    let purchaserPhoneNumber: String
    let depositorName: String
    let depositorPhoneNumber: String
    let salesEndTime: String
    let csReservationID: String
    let easyPayProvider: String?
    let paymentCardDetail: PaymentCardDetail?
}
