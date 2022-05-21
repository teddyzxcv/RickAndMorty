//
//  SearchTableView.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 26.04.2022.
//

import Foundation
import UIKit

final class CharacterTabelView: UITableView {
    
}

final class CharacterCollectionCell: UICollectionViewCell, Sendable {
    
    static let identifier = "CharacterCollectionCell"
    
    
    struct Model {
        let imageURL: URL
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 120),
            icon.topAnchor.constraint(equalTo: topAnchor),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor),
            icon.leftAnchor.constraint(equalTo: leftAnchor),
        ])
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            icon.layer.borderWidth = 1
            icon.layer.borderColor = UIColor.main.cgColor
            // light mode detected
        case .dark:
            icon.layer.borderWidth = 0
        default:
            return
            // dark mode detected
        }
        icon.layer.borderColor = UIColor.main.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ model: Model){
        icon.kf.setImage(with: model.imageURL)
    }
    
    private lazy var icon: UIImageView = {
        let ret = UIImageView()
        ret.layer.cornerRadius = 10
        ret.layer.masksToBounds = true
        ret.contentMode = .scaleAspectFill
        return ret
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch previousTraitCollection?.userInterfaceStyle {
        case .light, .unspecified:
            icon.layer.borderWidth = 0
        case .dark:
            icon.layer.borderWidth = 1
            icon.layer.borderColor = UIColor.main.cgColor
        default:
            return
            // dark mode detected
        }
    }
    
}


final class RecentCharacterTableCell: UITableViewCell {
    
    struct Model {
        let imageurls: [URL]
        let controller: UIViewController
    }
    
    var controller: UIViewController?
    
    static let identifier = "RecentCharacterTableCell"
    
    var imagesurls = [URL]()
    
    private let collectionViewLayout = UICollectionViewFlowLayout()
    
    func update(_ model: Model) {
        self.imagesurls = model.imageurls
        self.controller = model.controller
        collectionView.reloadData()
    }
    
    private lazy var collectionView: UICollectionView = {
        contentView.isUserInteractionEnabled = true
        let uv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        let layout = UICollectionViewFlowLayout()
        uv.translatesAutoresizingMaskIntoConstraints = false
        uv.dataSource = self
        uv.delegate = self
        uv.showsHorizontalScrollIndicator = false
        uv.showsVerticalScrollIndicator = false
        return uv
    }()
    
    func setUpRecentLabel() {
        let view = recentLabel
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 22)
        
        view.backgroundColor = .bg
        
        
        view.textColor = .main
        
        view.font = UIFont(name: "SFUIText-Semibold", size: 18)
        
        view.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        print("Font:")
        
        view.attributedText = NSMutableAttributedString(string: "Recent", attributes: [NSAttributedString.Key.kern: -0.2])
    }
    
    private lazy var recentLabel: UILabel = UILabel()
    
    func updateUI() {
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .bg
        self.contentView.backgroundColor = .bg
        
        self.selectionStyle = .none
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 200),
            contentView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        setUpRecentLabel()
        contentView.addSubview(recentLabel)
        recentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 16),
            recentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            recentLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        
        
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .bg
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: recentLabel.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        
        collectionView.register(CharacterCollectionCell.self, forCellWithReuseIdentifier: CharacterCollectionCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecentCharacterTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesurls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionCell.identifier, for: indexPath) as! CharacterCollectionCell
        cell.update(CharacterCollectionCell.Model(imageURL: imagesurls[indexPath.row]))
        return cell
    }
}



extension RecentCharacterTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CharacterViewController(model: CharacterViewController.Model(imageURL: imagesurls[indexPath.row]))
        vc.modalPresentationStyle = .overFullScreen
        controller?.navigationController?.pushViewController(vc, animated: true)
        controller?.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension RecentCharacterTableCell: UICollectionViewDelegateFlowLayout {
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionViewLayout.scrollDirection = .horizontal
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  120, height: collectionView.frame.height)
    }
}

