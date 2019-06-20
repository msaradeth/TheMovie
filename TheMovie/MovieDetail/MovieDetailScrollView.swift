//
//  DetailVCScrollView.swift
//  TheMovie
//
//  Created by Mike Saradeth on 6/20/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit


class DetailVCScrollView: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .black
        return scrollView
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    lazy var headerImage: UIImageView = {
        let headerImage = UIImageView(frame: .zero)
        headerImage.translatesAutoresizingMaskIntoConstraints = false
        headerImage.clipsToBounds = true
        headerImage.contentMode = .scaleAspectFill  //UIView.ContentMode.scaleToFill
        return headerImage
    }()
    lazy var movieTitle: UILabel = {
        let movieTitle = UILabel()
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
        movieTitle.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        movieTitle.textColor = .white
        return movieTitle
    }()
    lazy var movieDescription: UILabel = {
        let movieDescription = UILabel()
        movieDescription.translatesAutoresizingMaskIntoConstraints = false
        movieDescription.sizeToFit()
        movieDescription.numberOfLines = 0
        movieDescription.textColor = .lightGray
        return movieDescription
    }()
    lazy var labelStackView: UIStackView = {
        let labelStackView = UIStackView()
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.isLayoutMarginsRelativeArrangement = true
        labelStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return labelStackView
    }()
    fileprivate let defaultHeight: CGFloat = 350
    
    init(movie: Movie, index: Int, delegate: LoadImagesDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        movieTitle.text = movie.title
        movieDescription.text = movie.overview
        if let image = movie.backdropImageCache {
            headerImage.image = image
        }else {
            delegate?.loadImage(imageType: .backdrop, index: index, completion: { [weak self] (image) in
                DispatchQueue.main.async {
                    self?.headerImage.image = image
                }
            })
        }
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImageTransparent()
        view.layoutIfNeeded()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImageVisible()
    }
    
    
    func setupViews() {
        //Add scrollveiw to mainview
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        //stackview to scrollview - auto dynamic contentsize
        scrollView.addSubview(stackView)
        stackView.fillSuperview()
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        //Add views to stackview
        stackView.addArrangedSubview(headerImage)
        stackView.addArrangedSubview(labelStackView)
        
        //label stackview
        labelStackView.addArrangedSubview(movieTitle)
        labelStackView.addArrangedSubview(movieDescription)
        
        //set Height of image and label
        headerImage.heightAnchor.constraint(equalToConstant: defaultHeight).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailVCScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            let offsetY = abs(scrollView.contentOffset.y)
            let offsetX = offsetY * 0.5 //take percentage of offsetY
            headerImage.frame = CGRect(x: -offsetX, y: -offsetY, width: scrollView.bounds.size.width + (2 * offsetX), height: defaultHeight + offsetY)
        } else {
            headerImage.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.size.width, height: defaultHeight)
        }
    }
}


