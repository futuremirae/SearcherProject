//
//  ViewController.swift
//  SearcherProject
//
//  Created by 김미래 on 2/26/25.
//

import UIKit
import Combine

final class SearchViewController: UICollectionViewController {

  // MARK: - Properties
  private let viewModel = ImageCellViewModel()
  private var cancellables = Set<AnyCancellable>()
  private var searchText = ""

  private var searchController = UISearchController(searchResultsController: nil)

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
    collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.imageCellIdentifier)
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
    viewModel.searchImage
      .receive(on: DispatchQueue.main)
      .sink {  [ weak self ] searchImageList in
        self?.collectionView.reloadData()
      }
      .store(in: &cancellables)
  }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.searchImage.value.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.imageCellIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
    cell.configure(url: viewModel.searchImage.value[indexPath.row].thumbnail)

    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.bounds.width - 2) / 3
    return CGSize(width: width, height: width)
  }
}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text else { return }
    self.searchText = searchText
    if !searchText.isEmpty {
      viewModel.fetchSearhResults(searchTarget: searchText)
    } else {
      viewModel.searchImage.value = []
      collectionView.reloadData()
    }
  }
}

// MARK: - Paging
extension SearchViewController {
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
