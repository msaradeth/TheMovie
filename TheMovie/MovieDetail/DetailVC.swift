//
//  DetailVC.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/15/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DetailVC: UICollectionViewController {
    var movie: Movie
    
    init(movie: Movie, index: Int, delegate: LoadImagesDelegate?) {
        self.movie = movie
        let stretchHeaderFlowLayout = StretchHeaderFlowLayout()
        super.init(collectionViewLayout: stretchHeaderFlowLayout)
        
        //setup header image
        self.setupCollectionView()
        if movie.backdropImageCache != nil {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }else {
            self.loadImage(index: index, delegate: delegate)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.setBackgroundImageTransparent()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImageVisible()
    }
    
    //MARK:  setupCollectionView
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.register(UINib(nibName: "DetailCell", bundle: nil), forCellWithReuseIdentifier: DetailCell.cellIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.cellIdentifier)
    }
    
    func loadImage(index: Int, delegate: LoadImagesDelegate?) {
        delegate?.loadImage(imageType: .backdrop, index: index, completion: { [weak self] (image) in
            guard let self = self else { return }
            self.movie.backdropImageCache = image
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    // MARK: UICollectionView Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.cellIdentifier, for: indexPath) as? HeaderView
        
        headerView?.imageView.image = movie.backdropImageCache
        return headerView!
    }
    
    //MARK: UICollectionViewDelegate and UICollectionViewDatasource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCell.cellIdentifier, for: indexPath) as! DetailCell
        cell.configure(movie: movie)
        return cell
    }
    
    //MARK: viewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: UICollectionViewDelegateFlowLayout
extension DetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCell.cellIdentifier, for: indexPath) as! DetailCell
        
        let minHeight = collectionView.frame.height - 350 - navigationBarHeight()
        let height = minHeight > cell.cellHeight ? minHeight : cell.cellHeight
        return CGSize(width: collectionView.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 350)
    }
}


