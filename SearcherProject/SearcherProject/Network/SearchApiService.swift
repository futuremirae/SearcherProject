//
//  SearchApiService.swift
//  SearcherProject
//
//  Created by 김미래 on 2/26/25.
//

import Foundation

final class SearchApiService {

  // MARK: - Properties
  static let shared = SearchApiService()
  private let baseURL = "https://openapi.naver.com/v1/search/image?"
  private let session = URLSession.shared

  private init() {}

  func fetchSearhResults(searchTarget: String, page: Int, completion: @escaping (Result<[SearchImage], Error>) -> Void) {

    let display = 27
    let start = (page - 1) * display + 1

    if start > 1000 {
      print("start 값이 1000을 초과하여 요청 중단")
      completion(.failure(NetworkError.noData))
      return
    }

    let request = makeRequest(endpoint: "query=\(searchTarget)&display=\(display)&start=\(start)", method: .get)

    session.dataTask(with: request) { data, response, error in
      if error != nil {
        print(error!)
        completion(.failure(NetworkError.noData))
        return
      }

      guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
        print("네트워크 에러")
        completion(.failure(NetworkError.statusCodeError))
        return
      }

      guard let safeData = data else {
        return
      }

      if let parseData = self.parseJson(safeData) {
        if parseData.count < display {
          completion(.failure(NetworkError.noData))
          return
        }
        completion(.success(parseData))
      } else {
        completion(.failure(NetworkError.noData))
      }

    }.resume()
  }

//  func fetchSearhResults(searchTarget: String, page: Int, completion: @escaping ([SearchImage]?) -> Void) {
//
//    let display = 27
//    let start = (page - 1) * display + 1
//
//    if start > 1000 {
//      print("start 값이 1000을 초과하여 요청 중단")
//      completion(nil)
//      return
//    }
//
//    let request = makeRequest(endpoint: "query=\(searchTarget)&display=\(display)&start=\(start)", method: .get)
//
//    session.dataTask(with: request) { data, response, error in
//      if error != nil {
//        print(error!)
//        return
//      }
//
//      guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
//        print("네트워크 에러")
//        return
//      }
//
//      guard let safeData = data else {
//        return
//      }
//
//      if let parseData = self.parseJson(safeData) {
//        if parseData.count < display {
//          completion(nil)
//          return
//        }
//        completion(parseData)
//      } else {
//        completion(nil)
//      }
//
//    }.resume()
//  }

  func makeRequest(endpoint: String, method: HTTPMethod, body: Data? = nil) -> URLRequest {
    var request = URLRequest(url: URL(string: "\(baseURL)\(endpoint)")!)
    request.httpMethod = method.rawValue
    request.addValue("Co62NpcjrG3s8XuTKQ7L", forHTTPHeaderField: "X-Naver-Client-Id")
    request.addValue("oOMUQhy9Cw", forHTTPHeaderField: "X-Naver-Client-Secret")

    request.httpBody = body
    return request
  }

  func parseJson(_ searchData: Data) -> [SearchImage]? {
    do {
      let decoder = JSONDecoder()
      let decoderData = try decoder.decode(SearchImageItems.self, from: searchData)
      return decoderData.items
    } catch {
      return nil
    }
  }
}
