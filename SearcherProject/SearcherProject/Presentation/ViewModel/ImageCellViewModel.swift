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

//  @Published var searchImage: [SearchImage] = []
  var searchImage = CurrentValueSubject<[SearchImage], Never>([])
  func fetchSearhResults(searchTarget: String) {
    if self.searchTarget != searchTarget {
      self.searchTarget = searchTarget
      page = 1
      searchImage.value = []
    }

    guard !isLoading else { return }
    self.isLoading = true
    
    SearchApiService.shared.fetchSearhResults(searchTarget: searchTarget, page: page) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          if self.page == 1 {
            self.searchImage.value = data
          } else {
            self.searchImage.value.append(contentsOf: data)
          }
          self.page += 1

        case .failure(let error):
          self.searchImage.value = []
        }
        self.isLoading = false
      }
    }
  }
}
