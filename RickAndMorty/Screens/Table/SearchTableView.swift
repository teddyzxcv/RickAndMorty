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

final class CharacterCollectionCell: UICollectionViewCell {
    
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
    
}


final class CharacterTableCell: UITableViewCell {
    
    struct Model {
        let imageurls: [URL]
        let controller: UIViewController
    }
    
    var controller: UIViewController?
    
    static let identifier = "CharacterTableCell"
    
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
        return uv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 200),
            contentView.heightAnchor.constraint(equalToConstant: 200)
        ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        collectionView.register(CharacterCollectionCell.self, forCellWithReuseIdentifier: CharacterCollectionCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CharacterTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesurls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionCell.identifier, for: indexPath) as! CharacterCollectionCell
        cell.update(CharacterCollectionCell.Model(imageURL: imagesurls[indexPath.row]))
        return cell
    }
}



extension CharacterTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CharacterViewController(model: CharacterViewController.Model(imageURL: imagesurls[indexPath.row]))
        vc.modalPresentationStyle = .overFullScreen
        controller?.navigationController?.pushViewController(vc, animated: true)
        controller?.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension CharacterTableCell: UICollectionViewDelegateFlowLayout {
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionViewLayout.scrollDirection = .horizontal
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 23, right: 0))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  120, height: collectionView.frame.height)
    }
}

