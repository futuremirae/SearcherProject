//
//  ImageCell.swift
//  SearcherProject
//
//  Created by 김미래 on 2/26/25.
//

import UIKit

final class ImageCell: UICollectionViewCell {
  static let imageCellIdentifier = "ImageCell"

  // MARK: - Properties
  private let imageView: UIImageView = {
    let view = UIImageView()
    view.backgroundColor = .lightGray
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
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
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
  
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

  func configure(url: String) {
    guard let url = URL(string: url) else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
      if let error = error {
        print("이미지 다운 에러 \(error)")
      }

      guard let data = data, let image = UIImage(data: data) else {
        return
      }

      DispatchQueue.main.async {
        self.imageView.image = image

      }
    }.resume()
  }
}
