//
//  BankEntity.swift
//  Boolti
//
//  Created by Miro on 2/13/24.
//

import UIKit

struct BankEntity {
    let bankName: String
    let bankCode: String
    let bankIconImage: UIImage

    static var all: [BankEntity] {
        return [
            BankEntity(bankName: "산업은행", bankCode: "002", bankIconImage: .bankIcon002),
            BankEntity(bankName: "기업은행", bankCode: "003", bankIconImage: .bankIcon003),
            BankEntity(bankName: "국민은행", bankCode: "004", bankIconImage: .bankIcon004),
            BankEntity(bankName: "수협은행", bankCode: "007", bankIconImage: .bankIcon007),
            BankEntity(bankName: "농협은행", bankCode: "011", bankIconImage: .bankIcon011),
            BankEntity(bankName: "우리은행", bankCode: "020", bankIconImage: .bankIcon020),
            BankEntity(bankName: "SC제일은행", bankCode: "023", bankIconImage: .bankIcon023),
            BankEntity(bankName: "한국씨티은행", bankCode: "027", bankIconImage: .bankIcon027),
            BankEntity(bankName: "대구은행", bankCode: "031", bankIconImage: .bankIcon031),
            BankEntity(bankName: "부산은행", bankCode: "032", bankIconImage: .bankIcon039),
            BankEntity(bankName: "광주은행", bankCode: "034", bankIconImage: .bankIcon034),
            BankEntity(bankName: "제주은행", bankCode: "035", bankIconImage: .bankIcon088),
            BankEntity(bankName: "전북은행", bankCode: "037", bankIconImage: .bankIcon037),
            BankEntity(bankName: "경남은행", bankCode: "039", bankIconImage: .bankIcon039),
            BankEntity(bankName: "새마을금고", bankCode: "045", bankIconImage: .bankIcon045),
            BankEntity(bankName: "신협", bankCode: "048", bankIconImage: .bankIcon048),
            BankEntity(bankName: "토스뱅크", bankCode: "092", bankIconImage: .bankIcon092),
            BankEntity(bankName: "상호저축", bankCode: "050", bankIconImage: .bankIcon050),
            BankEntity(bankName: "산림조합", bankCode: "064", bankIconImage: .bankIcon064),
            BankEntity(bankName: "우체국", bankCode: "071", bankIconImage: .bankIcon071),
            BankEntity(bankName: "하나은행", bankCode: "081", bankIconImage: .bankIcon081),
            BankEntity(bankName: "신한은행", bankCode: "088", bankIconImage: .bankIcon088),
            BankEntity(bankName: "케이뱅크", bankCode: "089", bankIconImage: .bankIcon089),
            BankEntity(bankName: "카카오뱅크", bankCode: "090", bankIconImage: .bankIcon090)
        ]
    }

    static var bankCodeDictionary: [String: String] = [
        "산업은행": "002",
        "기업은행": "003",
        "국민은행": "004",
        "수협은행": "007",
        "농협은행": "011",
        "우리은행": "020",
        "SC제일은행": "023",
        "한국씨티은행": "027",
        "대구은행": "031",
        "부산은행": "032",
        "광주은행": "034",
        "제주은행": "035",
        "전북은행": "037",
        "경남은행": "039",
        "새마을금고": "045",
        "신협": "048",
        "상호저축": "050",
        "토스뱅크": "092",
        "산림조합": "064",
        "우체국": "071",
        "하나은행": "081",
        "신한은행": "088",
        "케이뱅크": "089",
        "카카오뱅크": "090"
    ]
}
