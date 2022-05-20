//
//  SearchBarView.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 19.05.2022.
//

import Foundation
import UIKit

class SearchBarView: UITextField {
    
    init() {
        super.init(frame: CGRect())
    }
    
    func setUp() {
        var placeHolderFont = UIFont(name: "SFUIText-Semibold", size: 18)
        placeHolderFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.font = placeHolderFont
        self.textColor = .main
        self.attributedPlaceholder = NSMutableAttributedString(string: "Search for character", attributes: [NSAttributedString.Key.font : placeHolderFont!, NSAttributedString.Key.foregroundColor : UIColor.secondary,])
        self.layer.cornerRadius = 10
        self.layer.borderWidth = CGFloat(2)
        self.leftViewMode = .always
        let boundView = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
        let iconView = UIImageView(image: UIImage(named: "Search") )
        boundView.translatesAutoresizingMaskIntoConstraints = false
        boundView.addSubview(iconView)
        //        iconView.translatesAutoresizingMaskIntoConstraints = false
        self.leftView = boundView
        iconView.center.x = boundView.center.x
        iconView.center.y = boundView.center.y
        
        self.leftView?.tintColor = .main
        self.layer.borderColor = UIColor.main.cgColor
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.layer.borderColor = UIColor.main.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += 12
        return textRect
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12 + 28 + 10, bottom: 0, right: 0))
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12 + 28 + 10, bottom: 0, right: 0))
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12 + 28 + 10, bottom: 0, right: 0))
    }
}
