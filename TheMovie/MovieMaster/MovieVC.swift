//
//  SearchVC.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class MovieVC: UICollectionViewController {
    lazy var searchController: UISearchController = {
       let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Movies"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .white
        UISearchBar.setSearchBarAppearance()
        return searchController
    }()
    var viewModel: MovieViewModel
    
    init(viewModel: MovieViewModel, query: String? = nil) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationItem.title = ""
        self.collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.cellIdentifier)
        self.navigationItem.titleView = searchController.searchBar
        
        //if given search text, search for the movies
        if let query = query {
            viewModel.search(query: query) { [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.transparent()
    }
    
    //MARK: UICollectionViewDatasource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.cellIdentifier, for: indexPath) as! MovieCell
        cell.configure(movie: viewModel[indexPath.row], index: indexPath.row, delegate: viewModel)
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailVC(movie: viewModel[indexPath.row], index: indexPath.row, delegate: viewModel)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: viewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init?(coder aDecoder: NSCoder)")
    }
}


//MARK: UISearchBarDelegate - search for movies
extension MovieVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBar.resignFirstResponder()
        viewModel.search(query: query) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension MovieVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        //Number of rows and columns
        let numberOfRows: CGFloat = 2
        var numberOfColumns: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 3
        if UIDevice.current.userInterfaceIdiom == .pad
            && (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight) {
            numberOfColumns = 4
        }

        //Calc available width and height
        let availableWidth = flowLayout.availableWidth(collectionViewWidth: collectionView.bounds.width, numberOfColumns: numberOfColumns)
        let availableHeight = flowLayout.availableHeight(collectionViewHeight: collectionView.bounds.height, numberOfRows: numberOfRows, navigationBarHeight: navigationBarHeight())
        
        //Calc Cell width and height
        let cellWidth = availableWidth / numberOfColumns
        let cellHeight = availableHeight / numberOfRows
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
