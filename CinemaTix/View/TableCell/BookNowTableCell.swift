//
//  BookNowTableCell.swift
//  CinemaTix
//
//  Created by Eky on 28/12/23.
//

import UIKit
import RxSwift
import RxCocoa

class BookNowDateTableCell: BaseTableCell {
    
    public var viewModel: BookNowViewModel?
    
    private let base = UIView()
    
    private let disposeBag = DisposeBag()
    
    private let collection = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = .init(width: 120, height: 120)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let coll = UICollectionView(frame: CGRect(x: 0, y: 0, width: 360, height: 160), collectionViewLayout: layout)
        coll.showsHorizontalScrollIndicator = false
        return coll
    }()
    
    override func setup() {
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(cell: DateItemCell.self)
        
        base.backgroundColor = .lightGray
        contentView.addSubview(base)
        
        base.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
            make.height.equalTo(56)
        }
        
        base.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self.base)
        }
    }
}

extension BookNowDateTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.sevenDays.count ?? 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as DateItemCell
        setupCell(cell, indexPath.row)
        return cell
    }
    
    func setupCell(_ cell: DateItemCell, _ index: Int) {
        if let theDay =  viewModel?.sevenDays[index] {
            cell.dateLabel.text = theDay.getDayOfWeek().formatted()
            if theDay.getDayOfWeek() == Date.now.getDayOfWeek() {
                cell.dayLabel.text = "Today"
            } else {
                cell.dayLabel.text = theDay.getDayName()
            }
            
            cell.onTap = {
                self.viewModel?.selectedDateRelay.accept(index)
            }
            
            viewModel?.selectedDateRelay.bind(onNext: { _index in
                cell.didSelectedCell(_index == index)
            }).disposed(by: disposeBag)
        }
    }
}

class DateItemCell: BaseCollectionCell {
    
    private let base = UIView()
    
    public let dateLabel = UILabel()
    public let dayLabel = UILabel()
    
    override func setup() {
        
        base.backgroundColor = .secondarySystemFill
        base.makeCornerRadius(12)
        base.clipsToBounds = true
        
        contentView.addSubview(base)
        base.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(self.contentView)
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        base.addSubviews(dateLabel, dayLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.base)
            make.centerY.equalTo(self.base).offset(16)
        }
        dayLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.base)
            make.centerY.equalTo(self.base).offset(-16)
        }
        
    }
    
    func didSelectedCell(_ isSelected: Bool) {
        if isSelected {
            UIView.animate(withDuration: 0.12, delay: 0.0, options: .curveEaseOut, animations: {
                self.base.makeBorder(color: .accent)
            })
        } else {
            UIView.animate(withDuration: 0.12, delay: 0.0, options: .curveEaseOut, animations: {
                self.base.layer.borderWidth = 0
                self.base.layer.borderColor = nil
            })
            
        }
    }
}


class BookNowCinemaTableCell: BaseTableCell {
    
    public var viewModel: BookNowViewModel?
    
    private let base = UIView()
    
    private let collection = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = .init(width: 120, height: 52)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let coll = UICollectionView(frame: CGRect(x: 0, y: 0, width: 360, height: 160), collectionViewLayout: layout)
        coll.showsHorizontalScrollIndicator = false
        return coll
    }()
    
    override func setup() {
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(cell: TimeItemCell.self)
        
        base.backgroundColor = .systemGroupedBackground
        contentView.addSubview(base)
        
        base.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
            make.height.equalTo(200)
        }
        
        base.addSubviews(collection)
        collection.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.left.right.equalTo(self.base)
            make.centerX.equalTo(self.base)
            make.bottom.equalTo(self.base.snp.bottom)
        }
    }
}

extension BookNowCinemaTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TimeItemCell
        cell.timeLabel.text = "10.00"
        return cell
    }
}

class TimeItemCell: BaseCollectionCell {
    
    private let base = UIView()
    
    public let timeLabel = UILabel()
    
    override func setup() {
        
        base.backgroundColor = .systemBackground
        base.makeBorder(color: .accent)
        base.makeCornerRadius(6)
        base.clipsToBounds = true
        
        contentView.addSubview(base)
        base.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalTo(120)
            make.top.left.right.bottom.equalTo(self.contentView)
        }
        
        base.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.center.equalTo(self.base)
        }
    }
}
