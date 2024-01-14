//
//  WalletTableCell.swift
//  CinemaTix
//
//  Created by Eky on 20/12/23.
//

import UIKit

class TransactionsTableCell: BaseTableCell {
    
    private let base = UIView()
    
    public let subtitle = UILabel()
    public let amount = UILabel()
    public let icon = UIImageView()
    
    override func setup() {
        
        isSelected = false
        isHighlighted = false
        
        contentView.addSubview(base)
        
        base.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
            make.height.equalTo(56)
        }
        
        subtitle.font = .regular(14)
        subtitle.textColor = .label.withAlphaComponent(0.72)
        
        base.addSubviews(subtitle, amount, icon)
        
        amount.snp.makeConstraints { make in
            make.top.equalTo(base).offset(8)
            make.left.equalTo(base).offset(16)
        }
        
        icon.snp.makeConstraints { make in
            make.centerY.equalTo(base)
            make.right.equalTo(base).offset(-16)
        }
        
        subtitle.snp.makeConstraints { make in
            make.bottom.equalTo(base).offset(-8)
            make.left.equalTo(base).offset(16)
        }
    }
}

class TopUpTableCell: BaseTableCell {
    
    private let base = UIView()
    
    private let button = FilledButton(title: "Top Up", icon: AppIcon.up, iconSize: CGSize(width: 24, height: 24), backgroundColor: .systemGray6, foregroundColor: .accent)
    
    var onTapButton: (() -> Void)?
    
    override func setup() {
        
        isSelected = false
        isHighlighted = false
        
        contentView.addSubview(base)
        
        base.snp.makeConstraints { make in
            make.top.bottom.right.left.equalTo(contentView)
            make.height.equalTo(60)
        }
        
        base.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.base).inset(8)
            make.left.right.equalTo(self.base).inset(16)
        }
        
        button.addAction(UIAction { _ in
            self.onTapButton?()
        }, for: .touchUpInside)
    }
}

