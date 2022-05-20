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
    
    let infoView = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .bg
        self.contentView.backgroundColor = .bg
        self.selectionStyle = .none
        updateUI()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func setUpInfoView() {
        contentView.addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 33),
            infoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -33),
            infoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 160),
            infoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
        ])
        infoView.addSubview(nameLabel)
        
        nameLabel.backgroundColor = .bg
        
        nameLabel.lineBreakMode = .byWordWrapping
        
        nameLabel.textColor = .main
        
        nameLabel.font = UIFont(name: "SFUIText-Bold", size: 22)
        
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoView.trailingAnchor, constant: -102)
        ])
        infoView.addSubview(speciesLabel)
        
        speciesLabel.frame = CGRect(x: 0, y: 0, width: 58, height: 22)
        
        speciesLabel.backgroundColor = .bg
        
        speciesLabel.textColor = .secondary
        
        speciesLabel.font = UIFont(name: "SFUIText-Semibold", size: 17)
        
        speciesLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            speciesLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            speciesLabel.bottomAnchor.constraint(lessThanOrEqualTo: infoView.bottomAnchor)
        ])
        
        infoView.sizeToFit()
        NSLayoutConstraint.activate([
            infoView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        nameLabel.numberOfLines = 2
    }
    
    func setUpImageView() {
        contentView.addSubview(avatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 16),
            avatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -23),
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 120)
        ])
        avatar.layer.cornerRadius = 10
        avatar.layer.borderWidth = CGFloat(1)
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.layer.borderColor = UIColor.main.cgColor
    }
    
    func update(_ model: CharacterModel) {
        avatar.kf.setImage(with: model.image)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.07
        nameLabel.attributedText = NSMutableAttributedString(string: model.name, attributes: [NSAttributedString.Key.kern: 0.35, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        speciesLabel.attributedText = NSMutableAttributedString(string: model.species, attributes: [NSAttributedString.Key.kern: -0.41, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    func updateUI() {
        setUpImageView()

        setUpInfoView()
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 200),
            contentView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        avatar.layer.borderColor = UIColor.main.cgColor
    }
}
