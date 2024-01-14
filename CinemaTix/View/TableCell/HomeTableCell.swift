//
//  HomeTableCell.swift
//  CinemaTix
//
//  Created by Eky on 13/12/23.
//

import UIKit
import SnapKit
import SkeletonView

class HomeTableCell: BaseTableCell {
    
    private let base = UIView()
    
    override var isHighlighted: Bool {
        didSet {
            
            var transform: CGAffineTransform = .identity
            if isHighlighted {
                transform = .init(scaleX: 0.95, y: 0.95)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1) {
                self.transform = transform
            }
        }
    }
    
    override func setup() {
        
        isSelected = false
        isHighlighted = false
        
        contentView.backgroundColor = .systemBlue
        contentView.addSubview(base)
        
        base.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
            make.height.equalTo(200)
        }
    }
    
    func applyShadow() {
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 6
        layer.shadowOffset = .init(width: 0, height: 6)
        layer.shadowColor = UIColor.systemGray.cgColor
    }

}

class RecomendedTableCell: BaseTableCell {
    
    private let collection = {
        let coll = UICollectionView(frame: CGRect(x: 0, y: 0, width: 360, height: 360), collectionViewLayout: UICollectionViewFlowLayout())
        coll.showsHorizontalScrollIndicator = false
        coll.isPagingEnabled = true
        return coll
    }()
    
    private var movies: [MovieModel]?
    
    public var size: CGSize = CGSize(width: 360, height: 360)
    
    public var onTapCell: ((Int) -> Void)?
    
    public var isLoading: Bool = false
    
    override func setup() {
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(cell: RecommendedItemCell.self)
        contentView.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
            make.height.equalTo(360)
        }
        
        if let collFlowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            collFlowLayout.scrollDirection = .horizontal
            collFlowLayout.itemSize = CGSize(width: size.width+16, height: size.height)
            collFlowLayout.minimumLineSpacing = 0
            collFlowLayout.minimumInteritemSpacing = 0
            collFlowLayout.sectionInset = .zero
        }
    }
    
    func updateMovies(_ movies: [MovieModel]) {
        self.movies = movies
        collection.reloadData()
    }
}

extension RecomendedTableCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, movies?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as RecommendedItemCell
        
        if isLoading {
            cell.showAnimatedSkeleton()
        } else {
            cell.hideSkeleton()
        }
        
        setupCell(cell, indexPath.row)
        return cell
    }
    
    func setupCell(_ cell: RecommendedItemCell, _ index: Int) {
        if let movie = movies?[index] {
            cell.title.text = movie.title ?? "-"
            if let rate = movie.voteAverage {
                cell.subtitle.text = movie.genres().joined(separator: ", ") + " • " + String(format: "%.1f", rate)
            }
            if let backdropPath = movie.backdropPath {
                let path = String(backdropPath.dropFirst())
                cell.backgroundImage.loadFromUrl(url: TmdbApi.getImageURL(path, type: .w500), usePlaceholder: true, isCompressed: true)
            }
            cell.onTap = {
                self.onTapCell?(index)
            }
        }
    }
}

class RecommendedItemCell: BaseCollectionCell {
    
    private let base = UIView()
    public let backgroundImage = UIImageView()
    
    public let title = UILabel()
    public let subtitle = UILabel()
    private let boxBlur = UIView()
    
    override func setup() {
        
        isSelected = false
        isHighlighted = false
        
        contentView.clipsToBounds = true
        contentView.addSubview(base)
        base.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(contentView)
            make.height.equalTo(360)
        }
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.makeCornerRadius(16)
        backgroundImage.clipsToBounds = true
        base.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.height.width.equalTo(320)
            make.center.equalTo(base)
        }
        
        backgroundImage.image = UIImage(named: "imagenotfound")
        
        boxBlur.backgroundColor = .clear
        backgroundImage.addSubview(boxBlur)
        boxBlur.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(self.backgroundImage)
            make.bottom.equalTo(self.backgroundImage)
            make.centerX.equalTo(self.backgroundImage)
        }
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        boxBlur.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.width.height.equalTo(self.boxBlur)
            make.top.left.right.bottom.equalTo(self.boxBlur)
        }
        
        title.text = ""
        title.font = .medium(24)
        title.textColor = .white
        boxBlur.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(self.boxBlur).offset(16)
            make.left.equalTo(self.boxBlur).offset(16)
        }
        
        subtitle.text = ""
        subtitle.font = .regular(16)
        subtitle.textColor = .white
        boxBlur.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.bottom.equalTo(self.boxBlur).offset(-16)
            make.left.equalTo(self.boxBlur).offset(16)
        }
    }
}

class UpComingTableCell: BaseTableCell {
    
    private let collection = {
        let coll = UICollectionView(frame: CGRect(x: 0, y: 0, width: 360, height: 200), collectionViewLayout: UICollectionViewFlowLayout())
        coll.showsHorizontalScrollIndicator = false
        return coll
    }()
    
    private var movies: [MovieModel]?
    
    public var isLoading = false
    
    public var onTapCell: ((Int) -> Void)?
    
    override func setup() {
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(cell: UpComingItemCell.self)
        contentView.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
            make.height.equalTo(200)
        }
        
        if let collFlowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            collFlowLayout.scrollDirection = .horizontal
            collFlowLayout.itemSize = CGSize(width: 300, height: 200)
            collFlowLayout.minimumLineSpacing = 8
            collFlowLayout.minimumInteritemSpacing = 8
            collFlowLayout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func updateMovies(_ movies: [MovieModel]) {
        self.movies = movies
        collection.reloadData()
    }
}

extension UpComingTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, movies?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as UpComingItemCell
        
        if isLoading {
            cell.showAnimatedSkeleton()
        } else {
            cell.hideSkeleton()
        }
        
        setupCell(cell, indexPath.row)
        return cell
    }
    
    func setupCell(_ cell: UpComingItemCell, _ index: Int) {
        if let movie = movies?[index] {
            cell.title.text = movie.title ?? "-"
            if let backdropPath = movie.backdropPath {
                let path = String(backdropPath.dropFirst())
                cell.backgroundImage.loadFromUrl(url: TmdbApi.getImageURL(path, type: .w500), usePlaceholder: true, isCompressed: true)
            }
            cell.onTap = {
                self.onTapCell?(index)
            }
        }
    }
}

class UpComingItemCell: BaseCollectionCell {
    
    public let backgroundImage = UIImageView()
    
    public let title = UILabel()
    private let boxBlur = UIView()
    
    override func setup() {
        
        isSelected = false
        isHighlighted = false
        
        backgroundImage.image = UIImage(named: "imagenotfound2")
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.clipsToBounds = true
        
        contentView.clipsToBounds = true
        contentView.makeCornerRadius(16)
        
        contentView.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(200)
            make.width.equalTo(300)
        }
        
        boxBlur.backgroundColor = .clear
        backgroundImage.addSubview(boxBlur)
        boxBlur.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(self.backgroundImage)
            make.bottom.equalTo(self.backgroundImage)
            make.centerX.equalTo(self.backgroundImage)
        }
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        boxBlur.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.width.height.equalTo(self.boxBlur)
            make.top.left.right.bottom.equalTo(self.boxBlur)
        }
        
        title.text = ""
        title.font = .bold(24)
        title.textColor = .white
        boxBlur.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalTo(self.boxBlur)
            make.left.right.equalTo(self.boxBlur).inset(16)
        }
    }
}
