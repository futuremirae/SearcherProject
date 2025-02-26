//
//  File.swift
//  SearcherProject
//
//  Created by 김미래 on 2/26/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case statusCodeError
    case downloadImageError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL 주소입니다."
        case .noData:
            return "데이터가 존재하지 않습니다."
        case .statusCodeError:
            return "잘못된 응답입니다."
        case .downloadImageError:
            return "이미지 다운에 실패했습니다."
        }
    }
}

