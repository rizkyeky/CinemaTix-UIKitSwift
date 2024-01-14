//
//  SearchTableCell.swift
//  CinemaTix
//
//  Created by Eky on 15/12/23.
//

import UIKit
import SnapKit


class SearchTableCell: BaseTableCell {
    
    private let base = UIView()
    
    public let label = UILabel()
    
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
        
        contentView.addSubview(base)
        
        base.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
            make.height.equalTo(40)
        }
        base.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(base.snp.centerY)
            make.left.equalTo(base.snp.left).offset(16)
        }
    }
    
    func applyShadow() {
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 6
        layer.shadowOffset = .init(width: 0, height: 6)
        layer.shadowColor = UIColor.systemGray.cgColor
    }
    
}
