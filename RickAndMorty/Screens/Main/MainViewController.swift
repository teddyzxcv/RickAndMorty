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
    
    var imageZoomScrollView: ImageZoomScrollView!
    
    var isImageOpened = false
    
    let closeButton = UIButton()
    
    var topImageContraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageZoomScrollView = ImageZoomScrollView(frame: view.bounds)
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
        topImageContraint = imageZoomScrollView.topAnchor.constraint(equalTo: bookLabel.bottomAnchor, constant: 45.5)
        view.addSubview(imageZoomScrollView)
        imageZoomScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageZoomScrollView.set(image: UIImage(named: "Main_image")!)
        NSLayoutConstraint.activate([
            topImageContraint,
            imageZoomScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageZoomScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageZoomScrollView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width * imageZoomScrollView.imageZoomView.getAspectRatioHeightOnWidth())
        ])
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        imageZoomScrollView.addGestureRecognizer(tapGR)
        imageZoomScrollView.isUserInteractionEnabled = true
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
        self.view.addSubview(closeButton)
        closeButton.isHidden = true
        closeButton.setImage(UIImage(named: "Close_button"), for: .normal)
        closeButton.tintColor = .main
        closeButton.addTarget(self, action: #selector(closeImageTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16)
        ])
    }
    
    @objc func closeImageTapped(sender: UIButton) {
        topImageContraint.constant = 45.5
        UIView.animate(withDuration: 0.4, animations: { [self] in
            self.view.layoutIfNeeded()
            imageZoomScrollView.imageUnzoomable()
        }, completion: { checker in
            guard checker else { return }
        })
        closeButton.isHidden = !closeButton.isHidden
        isImageOpened = !isImageOpened
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        self.view.bringSubviewToFront(closeButton)
        guard sender.state == .ended && !isImageOpened else { return }
        topImageContraint.constant = 0 - bookLabel.frame.height - titleLabel.frame.height - 24 - self.view.safeAreaInsets.top
        UIView.animate(withDuration: 0.4, animations: { [self] in
            self.view.layoutIfNeeded()
            imageZoomScrollView.setCurrentMaxandMinZoomScale()
        }, completion: { checker in
            guard checker else { return }
        })
        closeButton.isHidden = !closeButton.isHidden
        isImageOpened = !isImageOpened
    }
}

extension UIImageView {
    func getAspectRatioHeightOnWidth() -> CGFloat {
        guard let image = image else { return 0 }
        return image.size.height / image.size.width
    }
}
