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
  private let clientId = Bundle.main.infoDictionary?["ClientID"] as! String
  private let clientSecret = Bundle.main.infoDictionary?["ClientSecret"] as! String

  private init() {}

  // MARK: - Methods
  func fetchSearhResults(searchTarget: String, display: Int = 27, page: Int, completion: @escaping (Result<[SearchImage], Error>) -> Void) {

    let start = (page - 1) * display + 1

    if start > 1000 {
      print("start 값이 1000을 초과하여 요청 중단")
      completion(.failure(NetworkError.noData))
      return
    }

    let request = makeRequest(endpoint: "query=\(searchTarget)&display=\(display)&start=\(start)", method: .get)

    session.dataTask(with: request) { data, response, error in
      if error != nil {
        completion(.failure(NetworkError.invalidURL))
        return
      }

      guard let response = response as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
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

  func makeRequest(endpoint: String, method: HTTPMethod, body: Data? = nil) -> URLRequest {
    var request = URLRequest(url: URL(string: "\(baseURL)\(endpoint)")!)

    request.httpMethod = method.rawValue
    request.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
    request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

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
