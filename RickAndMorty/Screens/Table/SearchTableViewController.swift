//
//  SearchTableViewController.swift
//  RickAndMorty
//
//  Created by ZhengWu Pan on 26.04.2022.
//

import Foundation
import UIKit

class SearchTableViewController: UIViewController {
    let tableView: UITableView = UITableView()
    override func viewDidLoad() {
        tableView.separatorColor = .main
        view.addSubview(tableView)
        view.backgroundColor = .bg
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        tableView.backgroundColor = .bg
        tableView.register(CharacterTableCell.self, forCellReuseIdentifier: CharacterTableCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
}

extension SearchTableViewController: UITableViewDelegate{
    
}

extension SearchTableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableCell.identifier, for: indexPath) as! CharacterTableCell
        var images = [URL]()
        for i in 1...10 {
            images.append(URL(string:"https://rickandmortyapi.com/api/character/avatar/\(i + indexPath.row * 10).jpeg")!)
        }
        cell.update(CharacterTableCell.Model(
            imageurls: images,
            controller: self
        ))
        return cell
    }
}