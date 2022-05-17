//
//  MainViewController.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 16.05.2022.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    let titleLabel = UILabel()
    
    let bookLabel = UILabel()
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        titleLabel.frame = CGRect(x: 0, y: 0, width: 343, height: 258)
        titleLabel.backgroundColor = .bg
        
        titleLabel.textColor = .main
        titleLabel.font = UIFont(name: "SFUIDisplay-Black", size: 72)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        self.view.addSubview(titleLabel)
        
        titleLabel.attributedText = NSMutableAttributedString(string: "RICK \nAND \nMORTY", attributes: [
            NSAttributedString.Key.strokeColor : UIColor.main,
            NSAttributedString.Key.foregroundColor : UIColor.bg,
            NSAttributedString.Key.strokeWidth : -2.0,
            NSAttributedString.Key.kern: 3,
          ])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // Use safe area
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        setView()
    }
    
    func setView() {
        bookLabel.frame = CGRect(x: 0, y: 0, width: 343, height: 100)
        bookLabel.backgroundColor = .bg
        
        bookLabel.textColor = .main
        bookLabel.font = UIFont(name: "SFUIDisplay-Black", size: 32)
        bookLabel.numberOfLines = 0
        bookLabel.lineBreakMode = .byWordWrapping
        
        self.view.addSubview(bookLabel)
        
        bookLabel.attributedText = NSMutableAttributedString(string: "CHARACTER\nBOOK", attributes: [NSAttributedString.Key.kern: 3])
        bookLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bookLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            bookLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bookLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
        
        
    }
}
