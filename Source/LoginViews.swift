//
//  LoginViews.swift
//  LoginUI
//
//  Created by xu on 2020/6/30.
//  Copyright © 2020 xaoxuu.com. All rights reserved.
//

import UIKit
import SnapKit

class TFLeftView: UIView {

    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (mk) in
            mk.center.equalToSuperview()
            mk.right.equalToSuperview().offset(-LoginUI.margin)
        }
        
        titleLabel.font = UIFont.init(name: LoginUI.textFieldFontName, size: 15)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TF: UITextField {
    
    var prefix: String? {
        set {
            leftV.titleLabel.text = newValue
        }
        get {
            return leftV.titleLabel.text
        }
    }
    private let leftV = TFLeftView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autocorrectionType = .no
        placeholder = placeholder
        font = UIFont.init(name: LoginUI.textFieldFontName, size: 15)
        clearButtonMode = .whileEditing
        leftViewMode = .always
        enablesReturnKeyAutomatically = true
        leftView = leftV
    }
    
    convenience init(returnKeyType: UIReturnKeyType, isSecureTextEntry: Bool) {
        self.init(frame: .zero)
        self.returnKeyType = returnKeyType
        self.isSecureTextEntry = isSecureTextEntry
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
