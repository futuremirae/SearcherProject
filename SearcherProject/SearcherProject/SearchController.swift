//
//  ViewController.swift
//  SearcherProject
//
//  Created by 김미래 on 2/26/25.
//

import UIKit

private let imageCellIdentifier = "ImageCell"
final class SearchController: UICollectionViewController {

  // MARK: - Properties
  private var searchController = UISearchController(searchResultsController: nil)


  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupSearchBar()
    collectionView.register(ImageCell.self, forCellWithReuseIdentifier: imageCellIdentifier)
    collectionView.dataSource = self
    collectionView.delegate = self
  }

  // MARK: - Methods
  func setupView() {
    view.backgroundColor = .white
    navigationItem.title = "검색창"
  }

  func setupSearchBar() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }


}

// MARK: - UICollectionViewDataSource
extension SearchController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 9
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (UIApplication.screenWidth - 2) / 3
    return CGSize(width: width, height: width)
  }

}


