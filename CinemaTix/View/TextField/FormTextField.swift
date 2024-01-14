//
//  FormTextField.swift
//  CinemaTix
//
//  Created by Eky on 13/12/23.
//

import UIKit

class FormTextField: UIView {
    
    public let field = UITextField()
    
    convenience init(placeholder: String? = nil, keyboardType: UIKeyboardType = .default, isPassword: Bool = false) {
        self.init(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        
        field.placeholder = placeholder
        field.keyboardType = keyboardType
        field.isSecureTextEntry = isPassword
        backgroundColor = .secondarySystemFill
        makeCornerRadius(8)
        makeBorder(color: AppColor.separator)
        
        addSubview(field)
        field.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(8)
            make.right.equalTo(self).offset(8)
        }
    }
}
