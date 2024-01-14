//
//  DetailMovieTableCell.swift
//  CinemaTix
//
//  Created by Eky on 18/12/23.
//

import UIKit

class DetailMovieOverviewTableCell: BaseTableCell {
    
    private let base = UIView()
    
    public let overview = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    override func setup() {
        
        contentView.addSubview(base)
        
        base.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView).inset(16)
            make.left.equalTo(contentView).inset(16)
        }
        
        base.addSubview(overview)
        overview.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(base)
        }
    }
}

class DetailMovieCastTableCell: BaseTableCell {
    
    private let collection = {
        let coll = UICollectionView(frame: CGRect(x: 0, y: 0, width: 360, height: 180), collectionViewLayout: UICollectionViewFlowLayout())
        coll.showsHorizontalScrollIndicator = false
        return coll
    }()
    
    private var casts: [CastModel]?
    
    override func setup() {
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(cell: CastItemCell.self)
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
            make.height.equalTo(180)
        }
        
        if let collFlowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            collFlowLayout.scrollDirection = .horizontal
            collFlowLayout.itemSize = CGSize(width: 180, height: 180)
            collFlowLayout.minimumLineSpacing = 8
            collFlowLayout.minimumInteritemSpacing = 8
            collFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func updateCasts(_ casts: [CastModel]) {
        self.casts = casts
        collection.reloadData()
    }
}

extension DetailMovieCastTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.casts?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CastItemCell
        setupCell(cell, indexPath.row)
        return cell
    }
    
    func setupCell(_ cell: CastItemCell, _ index: Int) {
        if let cast = casts?[index] {
            cell.title.text = cast.name ?? "-"
            if let backdropPath = cast.profilePath {
                let path = String(backdropPath.dropFirst())
                cell.backgroundImage.loadFromUrl(url: TmdbApi.getImageURL(path, type: .w500), usePlaceholder: true, isCompressed: true)
            }
        }
    }
}

class CastItemCell: BaseCollectionCell {
    
    public let backgroundImage = UIImageView(image: UIImage(named: "imagenotfound"))
    public let title = UILabel()
    
    override func setup() {
        
        isSelected = false
        isHighlighted = false
        
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.clipsToBounds = true
        contentView.clipsToBounds = true
        contentView.makeCornerRadius(16)
        contentView.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.width.height.equalTo(180)
        }
        
        let boxBlur = UIView()
        boxBlur.backgroundColor = .clear
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
        
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        title.textColor = .white
        title.numberOfLines = 2
        boxBlur.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.equalTo(boxBlur.snp.centerY)
            make.left.equalTo(boxBlur).offset(16)
            make.right.equalTo(boxBlur).inset(16)
        }
    }
}

class DetailMovieClipsTableCell: BaseTableCell {
    
    private let collection = {
        let coll = UICollectionView(frame: CGRect(x: 0, y: 0, width: 360, height: 160), collectionViewLayout: UICollectionViewFlowLayout())
        coll.showsHorizontalScrollIndicator = false
        return coll
    }()
    
    private var images: [ImageTmdb]?
    
    override func setup() {
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(cell: ClipItemCell.self)
        
        contentView.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
            make.height.equalTo(160)
        }
        
        if let collFlowLayout = collection.collectionViewLayout as? UICollectionViewFlowLayout {
            collFlowLayout.scrollDirection = .horizontal
            collFlowLayout.itemSize = CGSize(width: 240, height: 160)
            collFlowLayout.minimumLineSpacing = 8
            collFlowLayout.minimumInteritemSpacing = 8
            collFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func updateImages(_ images: [ImageTmdb]) {
        self.images = images
        collection.reloadData()
    }
}

extension DetailMovieClipsTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ClipItemCell
        setupCell(cell, indexPath.row)
        return cell
    }
    
    func setupCell(_ cell: ClipItemCell, _ index: Int) {
        if let cast = images?[index] {
            if let filePath = cast.filePath {
                let path = String(filePath.dropFirst())
                cell.backgroundImage.loadFromUrl(url: TmdbApi.getImageURL(path, type: .w500), usePlaceholder: true, isCompressed: true)
            }
        }
    }
}

class ClipItemCell: BaseCollectionCell {
    
    public let backgroundImage = UIImageView(image: UIImage(named: "imagenotfound"))
    
    override func setup() {
        
        isSelected = false
        isHighlighted = false
        
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.clipsToBounds = true
        contentView.clipsToBounds = true
        contentView.makeCornerRadius(16)
        contentView.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.width.equalTo(240)
            make.height.equalTo(160)
        }
    }
}
