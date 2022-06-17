//
//  FavouriteViewController.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 17.05.2022.
//

import Foundation
import UIKit
import SwiftUI

final class FavouriteViewController: UIViewController, Sendable {
    private let tableView = UITableView()
    
    private let noResultView = UILabel()
    
    private var favouriteCharacters = [CharacterModel]()
    
    private func loadFavouriteCharacters(_ ids: [Int]) {
        guard !ids.isEmpty else {
            tableView.reloadData()
            return
        }
        Task {
            for id in ids {
                guard let characterURL = ImageUtil.getCharacterURLbyID(id) else {continue}
                do {
                    let character = try await CharacterLoader().loadCharacter(characterURL)
                    self.favouriteCharacters.append(character)
                    
                } catch {
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        noResultView.textAlignment = .center
        favouriteCharacters.removeAll()
        let favouriteCharactersID = UserDefaults.standard.array(forKey: "Favourite characters") as? [Int]
        loadFavouriteCharacters(favouriteCharactersID ?? [Int]())
        tableView.reloadData()
        super.viewWillAppear(animated)
        tableView.setNeedsUpdateConstraints()
    }
    
    override func viewDidLoad() {
        tableView.tableHeaderView = UIView()
        navigationItem.title = "Favourite"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .bg
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        tableView.register(FavouriteTableViewCell.self, forCellReuseIdentifier: FavouriteTableViewCell.identifier)
    }
}

extension FavouriteViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard favouriteCharacters.count > 0 else { return }
//        let vc = CharacterViewController(characterModel: favouriteCharacters[indexPath.row])
//        vc.modalPresentationStyle = .overFullScreen
        let vc = UIHostingController(rootView: CharacterView(data: favouriteCharacters[indexPath.row]))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavouriteViewController: UITableViewDataSource{
    private func setUpNotResultView(_ view: UILabel) {
        view.textColor = .secondary

        view.backgroundColor = .bg
        view.font = UIFont(name: "SFUIText-Bold", size: 22)
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineHeightMultiple = 1.07
    
        view.attributedText = NSMutableAttributedString(string: "No favorites yet", attributes: [NSAttributedString.Key.kern: 0.35, NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favouriteCharacters.count == 0 {
            noResultView.textAlignment = .center
            noResultView.translatesAutoresizingMaskIntoConstraints = false
            tableView.backgroundView = noResultView
            setUpNotResultView(noResultView)
            NSLayoutConstraint.activate([
                noResultView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                noResultView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
            ])
            return 0
        } else {
            tableView.backgroundView = nil
            return favouriteCharacters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorColor = .main
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.identifier, for: indexPath) as! FavouriteTableViewCell
        cell.update(favouriteCharacters[indexPath.row])
        return cell
    }
}
