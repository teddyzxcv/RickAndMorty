//
//  FavouriteTableViewCell.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 19.05.2022.
//

import Foundation
import UIKit

final class FavouriteTableViewCell: UITableViewCell {
    struct Model {
        let url: URL
    }
    
    static public let identifier = "FavouriteTableViewCell"
    
    private var avatar = UIImageView()
    
    private let nameLabel = UILabel()
        
    private let infoView = UIView()
    
    private func setUpInfoView() {
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
        
        nameLabel.textColor = .main
        
        nameLabel.font = UIFont(name: "SFUIText-Bold", size: 22)
        
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: infoView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: infoView.trailingAnchor, constant: -102),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: infoView.trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor)
        ])
        nameLabel.numberOfLines = 0
        
        nameLabel.lineBreakMode = .byWordWrapping
        
        infoView.sizeToFit()
        NSLayoutConstraint.activate([
            infoView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])    }
    
    private func setUpImageView() {
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
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            avatar.layer.borderWidth = 1
            avatar.layer.borderColor = UIColor.main.cgColor
        case .dark:
            avatar.layer.borderWidth = 0
        default:
            return
            // dark mode detected
        }
    }
    
    private func updateUI() {
        setUpImageView()

        setUpInfoView()
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 159)
        ])
    }
    
    func update(_ model: CharacterModel) {
        avatar.kf.setImage(with: model.image)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.07
        var name = model.name
        if model.name.filter({$0 == " "}).count == 1 {
            name = model.name.replacingOccurrences(of: " ", with: "\n")
        }
        nameLabel.attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.kern: 0.35, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch previousTraitCollection?.userInterfaceStyle {
        case .light, .unspecified:
            avatar.layer.borderWidth = 0
        case .dark:
            avatar.layer.borderWidth = 1
            avatar.layer.borderColor = UIColor.main.cgColor
        default:
            return
            // dark mode detected
        }
    }
}
