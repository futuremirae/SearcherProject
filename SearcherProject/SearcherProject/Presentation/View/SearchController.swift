//
//  ViewController.swift
//  SearcherProject
//
//  Created by 김미래 on 2/26/25.
//

import UIKit
import Combine

private let imageCellIdentifier = "ImageCell"
final class SearchController: UICollectionViewController {

  // MARK: - Properties
  private let viewModel = ImageCellViewModel()
  private var cancellables = Set<AnyCancellable>()
  private var searchText = ""

  private var searchController = UISearchController(searchResultsController: nil)
  private var searchResult = [SearchImage]()

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    setupView()
    setupSearchBar()
  }

  // MARK: - Methods
  func setupView() {
    view.backgroundColor = .white
    navigationItem.title = "검색창"
    collectionView.register(ImageCell.self, forCellWithReuseIdentifier: imageCellIdentifier)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.isPagingEnabled = true
  }

  func setupSearchBar() {
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }

  func bind() {
    viewModel.$searchImage
      .receive(on: DispatchQueue.main)
      .sink {  [ weak self ] searchImageList in
        self?.searchResult.append(contentsOf: searchImageList)
        self?.collectionView.reloadData()
      }
      .store(in: &cancellables)
  }
}

// MARK: - UICollectionViewDataSource
extension SearchController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchResult.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
    cell.configure(url: searchResult[indexPath.row].link)

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

extension SearchController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }
    self.searchText = searchText
    self.searchResult = []
    if !searchText.isEmpty {
      viewModel.fetchSearhResults(searchTarget: searchText)
    } else {
      collectionView.reloadData()
    }
  }
}

// MARK: - Paging
extension SearchController {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let frameHeight = scrollView.frame.size.height

    if offsetY > contentHeight - frameHeight * 1.5 {
      if !searchText.isEmpty {
        viewModel.fetchSearhResults(searchTarget: searchText)
      }
    }
  }
}
