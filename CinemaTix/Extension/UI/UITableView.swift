//
//  UITableView.swift
//  CinemaTix
//
//  Created by Eky on 13/12/23.
//

import UIKit

extension UITableView {
    
    func register<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
//    func registerCellWithNib<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
//        let identifier = String(describing: cellClass)
//        let nib = UINib(nibName: identifier, bundle: .main)
//        register(nib, forCellReuseIdentifier: identifier)
//    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error for cell if: \(identifier) at \(indexPath)")
        }
        return cell
    }
    
}
