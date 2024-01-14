//
//  Array.swift
//  CinemaTix
//
//  Created by Eky on 14/12/23.
//

import Foundation

extension Array {
    func sliceArrayWithMax(_ max: Int) -> Array {
        if self.count > max {
            return Array(self.prefix(max+1))
        } else {
            return self
        }
    }
}
