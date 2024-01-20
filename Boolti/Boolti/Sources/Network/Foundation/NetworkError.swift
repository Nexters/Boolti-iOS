//
//  NetworkError.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

enum NetworkError: Int {
    case invalidRequest = 400
    case unauthorized   = 401
    case forbidden      = 403
    case notFound       = 404
    case duplicated     = 409
    case serverError    = 500
}
