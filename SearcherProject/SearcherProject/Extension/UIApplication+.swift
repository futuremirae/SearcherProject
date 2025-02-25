//
//  UIApplication+.swift
//  SearcherProject
//
//  Created by 김미래 on 2/26/25.
//

import UIKit

extension UIApplication {
  static var screenSize: CGSize {
    guard let windowScene = shared.connectedScenes.first as? UIWindowScene else {
      return UIScreen.main.bounds.size
    }
    return windowScene.screen.bounds.size
  }

  static let screenHeight: CGFloat = screenSize.height
  static let screenWidth: CGFloat = screenSize.width
}
