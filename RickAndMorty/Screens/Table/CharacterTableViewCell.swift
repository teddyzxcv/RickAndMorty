//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 19.05.2022.
//

import Foundation
import UIKit

class CharacterTableViewCell: UITableViewCell {
    struct Model {
        let url: URL
    }
    
    static let identifier = "CharacterTableViewCell"
    
    var avatar = UIImageView()
    
    let nameLabel = UILabel()
    
    let speciesLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .bg
        self.contentView.backgroundColor = .bg
        self.selectionStyle = .none

        
        contentView.addSubview(avatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 120),
            avatar.topAnchor.constraint(equalTo: topAnchor),
            avatar.bottomAnchor.constraint(equalTo: bottomAnchor),
            avatar.leftAnchor.constraint(equalTo: leftAnchor),
        ])
       
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 200),
            contentView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func update(_ model: CharacterModel) {
        avatar.kf.setImage(with: model.image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
