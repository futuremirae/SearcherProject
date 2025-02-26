//
//  ImageCellViewModel.swift
//  SearcherProject
//
//  Created by 김미래 on 2/26/25.
//

import Foundation
import Combine

class ImageCellViewModel: ObservableObject {
  private var isLoading = false
  private var page = 1
  private var searchTarget = ""

  @Published var searchImage: [SearchImage] = []

  func fetchSearhResults(searchTarget: String) {
    if self.searchTarget != searchTarget {
      self.searchTarget = searchTarget
      page = 1
      searchImage = []
    }

    guard !isLoading else { return }
    self.isLoading = true
    
    SearchApiService.shared.fetchSearhResults(searchTarget: searchTarget, page: page) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          if self.page == 1 {
            self.searchImage = data
          } else {
            self.searchImage.append(contentsOf: data)
          }
          self.page += 1
          self.isLoading = false
        case .failure(let error):
          print("에러 발생 \(error)")
        }
      }
    }
  }
}
