//
//  SearchVC.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class MovieVC: UICollectionViewController {
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 160, height: 44))
        searchBar.delegate = self
        searchBar.placeholder = "Search Movies"
        searchBar.tintColor = .white
        UISearchBar.setSearchBarAppearance()
        return searchBar
    }()
    var viewModel: MovieViewModel
    
    init(viewModel: MovieViewModel, query: String? = nil) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationItem.title = ""
        self.collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.cellIdentifier)
        self.navigationItem.titleView = searchBar
        
        //if given search text, search for the movies
        if let query = query {
            viewModel.search(query: query) { [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
//        let detailVC = DetailVC(movie: viewModel[indexPath.row], index: indexPath.row, delegate: viewModel)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let detailVC = DetailVCScrollView(movie: viewModel[indexPath.row], index: indexPath.row, delegate: viewModel)
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
        resetSearchBar()
        viewModel.search(query: query) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else { return }
        viewModel.search(query: query) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchBar()
    }
    func resetSearchBar() {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
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
        let cellHeight = cellWidth + (cellWidth*0.3)   //vailableHeight / numberOfRows
        return CGSize(width: cellWidth, height: cellHeight)
    }

    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let titleView = navigationItem.titleView, let navBar = self.navigationController?.navigationBar else { return }
        let translationSuperviewY = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y
        //        print(translationSuperviewY, scrollView.contentOffset.y)
        if translationSuperviewY > 0 {  //scroll dow
            titleView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: 60)
            navBar.alpha = translationSuperviewY / 60
            navBar.setBackgroundImageVisible()
        }else {
            var deltaHeight = titleView.frame.height - abs(scrollView.contentOffset.y)
            deltaHeight = deltaHeight < 0 ? 0 : deltaHeight
            titleView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: deltaHeight)
            navBar.setBackgroundImageTransparent()
        }
        self.view.layoutIfNeeded()
    }
    
}
