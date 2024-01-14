//
//  ListMovieViewController.swift
//  CinemaTix
//
//  Created by Eky on 20/12/23.
//

import UIKit

class ListMovieViewController: BaseViewController {
    
    private let collection = {
        let coll = UICollectionView(frame: CGRect(x: 0, y: 0, width: 360, height: 360), collectionViewLayout: UICollectionViewFlowLayout())
        coll.showsHorizontalScrollIndicator = false
        return coll
    }()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private var titlePage: String
    
    private let viewModel = ListMovieViewModel()
    
    private let type :ListMovieType
    
    init(titlePage: String, type :ListMovieType) {
        self.type = type
        self.titlePage = titlePage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collection.delegate = self
        collection.dataSource = self
        collection.register(cell: MovieItemCell.self)
        
        if let collFlowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            collFlowLayout.scrollDirection = .vertical
            collFlowLayout.itemSize = CGSize(width: 160, height: 200)
            collFlowLayout.minimumLineSpacing = 8
            collFlowLayout.minimumInteritemSpacing = 8
            collFlowLayout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        viewModel.getListMovie(listType: type) {
            self.loadingIndicator.stopAnimating()
            self.collection.reloadData()
        }
    }
    
    override func setupNavBar() {
        navigationItem.title = titlePage
    }
    
    override func setupConstraints() {
        view.addSubviews(collection, loadingIndicator)
        collection.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.view)
        }
        loadingIndicator.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.center.equalTo(self.collection)
        }
    }
}

extension ListMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setupCell(_ cell: MovieItemCell, _ index: Int) {
        let movie = viewModel.moviesTemp[index]
        
        cell.onTap = {
            self.navigationController?.pushViewController(DetailMovieViewController(movie: movie), animated: true)
        }
        
        cell.title.text = movie.title ?? "-"
        
        if let posterPath = movie.posterPath {
            let path = String(posterPath.dropFirst())
            cell.backgroundImage.loadFromUrl(url: TmdbApi.getImageURL(path))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moviesTemp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(forIndexPath: indexPath) as MovieItemCell
        setupCell(cell, indexPath.row)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            viewModel.getListMovie(listType: type) {
                print("Curr page: " + self.viewModel.currentPage.formatted())
                self.collection.reloadData()
            }
        }
    }
}

class MovieItemCell: BaseCollectionCell {
    
    public let backgroundImage = UIImageView(image: UIImage(named: "imagenotfound"))

    public let title = UILabel()
    
    override func setup() {
        
        addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.width.equalTo(160)
        }
    
        let boxBlur = UIView()
        boxBlur.backgroundColor = .clear
        backgroundImage.clipsToBounds = true
        backgroundImage.makeCornerRadius(16)
        backgroundImage.addSubview(boxBlur)
        boxBlur.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(self.backgroundImage)
            make.bottom.equalTo(self.backgroundImage)
            make.centerX.equalTo(self.backgroundImage)
        }
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        boxBlur.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.width.height.equalTo(boxBlur)
            make.top.left.right.bottom.equalTo(boxBlur)
        }
        
        title.text = "-"
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.textColor = .white
        title.numberOfLines = 2
        boxBlur.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalTo(boxBlur.snp.centerY)
            make.left.equalTo(boxBlur).offset(16)
            make.right.equalTo(boxBlur).offset(-16)
        }
    }
}
