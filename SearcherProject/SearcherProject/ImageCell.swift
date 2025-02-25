//
//  ImageCell.swift
//  SearcherProject
//
//  Created by 김미래 on 2/26/25.
//

import UIKit

class ImageCell: UICollectionViewCell {

  // MARK: - Properties
  private let imageView: UIImageView = {
    let view = UIImageView()
    view.backgroundColor = .lightGray
    view.contentMode = .scaleAspectFill
    return view
  }()

  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods
  func setupView() {
    contentView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }


}
