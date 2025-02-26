//
//  SearchImageItems.swift
//  SearcherProject
//
//  Created by 김미래 on 2/26/25.
//

import Foundation

struct SearchImage: Decodable {
  let title: String
  let thumbnail: String
  let link: String
}

struct SearchImageItems: Decodable {
  let items: [SearchImage]
}
