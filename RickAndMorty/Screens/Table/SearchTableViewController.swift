//
//  SearchTableViewController.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 26.04.2022.
//

import Foundation
import UIKit
import CoreMedia
import SwiftUI

class SearchTableViewController: UIViewController {
    var pagesCount: Int = 0
    
    var characterCount: Int = 0
    
    var nextPage: URL?
    
    var prevPage: URL?
    
    var searchedCharacters = [CharacterModel]()
    
    var characterTask = Task{
    }
    let tableView: UITableView = UITableView()
    
    let searchBarView = SearchBarView()
    
    var isStartEditing: Bool = false
    
    private func changeRecentTabelCellStatus() {
        isStartEditing = !isStartEditing
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        tableView.tableHeaderView = UIView()
        let searchRecentCharacterID = UserDefaults.standard.array(forKey: "Recent characters") as? [Int]
        if searchRecentCharacterID == nil {
            UserDefaults.standard.set([Int](),forKey: "Recent characters")
        }
        tableView.separatorColor = .main
        view.addSubview(tableView)
        view.backgroundColor = .bg
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up searchBar View
        view.addSubview(searchBarView)
        
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.delegate = self
        searchBarView.setUp()
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchBarView.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        // Set up tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = .bg
        tableView.register(RecentCharacterTableCell.self, forCellReuseIdentifier: RecentCharacterTableCell.identifier)
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
    }
}

extension SearchTableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard searchedCharacters.count > 0 else { return }
        let character = searchedCharacters[indexPath.row]
        let vc = CharacterViewController(characterModel: character)
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

extension SearchTableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchedCharacters.count <= 0 {
            return 1
        } else {
            return searchedCharacters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchedCharacters.count <= 0 && indexPath.row == 0 {
            tableView.separatorColor = .bg
            let cell = tableView.dequeueReusableCell(withIdentifier: RecentCharacterTableCell.identifier, for: indexPath) as! RecentCharacterTableCell
            var images = [URL]()
            let searchRecentCharacterID = UserDefaults.standard.array(forKey: "Recent characters") as? [Int]
            for i in searchRecentCharacterID?.reversed() ?? [Int]() {
                images.append(ImageLoader.getImageURLbyID(i)!)
            }
            cell.update(RecentCharacterTableCell.Model(
                imageurls: images,
                controller: self
            ))
            return cell
        } else {
            tableView.separatorColor = .main
            let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as! CharacterTableViewCell
            cell.update(searchedCharacters[indexPath.row])
            return cell
        }
    }
}

extension SearchTableViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeRecentTabelCellStatus()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        changeRecentTabelCellStatus()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        isStartEditing = false
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text
        guard text?.count != 0 else {
            characterTask.cancel()
            searchedCharacters.removeAll()
            tableView.reloadData()
            return
        }
        let url = URL(string: "https://rickandmortyapi.com/api/character/?name=\(text ?? "")".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        searchedCharacters.removeAll()
        characterTask.cancel()
        characterTask = Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url!)
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    searchedCharacters.removeAll()
                    tableView.reloadData()
                    return
                }
                guard let dict = try? JSONSerialization.jsonObject (with: data, options: .json5Allowed) as? [String: Any],
                let pageInfo = dict["info"] as? [String: Any] else {
                    return
                }
                self.characterCount = (pageInfo["count"] as? Int)!
                if self.characterCount == 0 {
                    tableView.reloadData()
                    return
                    
                }
                self.pagesCount = (pageInfo["pages"] as? Int)!
                let next = (pageInfo["next"] as? String)
                let prev = (pageInfo["next"] as? String)
                self.nextPage = next == nil ? nil : URL(string: next!)
                self.prevPage = prev == nil ? nil : URL(string: prev!)
                let characters = dict["results"] as? [Any]
                for i in 0..<(min(20, characterCount)) {
                    guard let characterDict = characters?[i] as? [String: Any] else { continue }
                    let id = characterDict["id"] as? Int
                    let name = characterDict["name"] as? String
                    let status = characterDict["status"] as? String
                    let species = characterDict["species"] as? String
                    let image = URL(string: (characterDict["image"] as? String)!)
                    let gender = characterDict["gender"] as? String
                    searchedCharacters.append(CharacterModel(id: id!, name: name!, status: status!, species: species!, gender: gender!, image: image!))
                }
                tableView.reloadData()
            } catch {
            }
        }
     
    }
}
