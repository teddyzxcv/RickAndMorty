@preconcurrency import Foundation
import UIKit
import Kingfisher
import CloudKit
import SwiftUI

final class CharacterViewController: UIViewController, Sendable {
    // MARK: All UIElements
    // TODO: Make scrollable
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let favouriteButton = UIButton()
        
    private lazy var icon: UIImageView = {
        let ret = UIImageView()
        ret.layer.cornerRadius = 10
        ret.layer.masksToBounds = true
        ret.layer.borderWidth = 1
        ret.contentMode = .scaleAspectFill
        return ret
    }()
    
    private lazy var nameLabel: UILabel = {
        let ret = UILabel()
        ret.font = .boldSystemFont(ofSize: 34)
        ret.textColor = .main
        return ret
    }()
    
    let nameAndButtonView = UIView()
    
    private lazy var infoTableView = UITableView()
    
    // MARK: All models.
    struct Model {
        let imageURL: URL
    }
    
    private var model: Model? = nil

    
    var characterModel: CharacterModel? {
        didSet {
            DispatchQueue.main.async { [self] in
                updateInfo()
                infoTableView.reloadData()
            }
        }
    }
        
    // MARK: Serialization method
    func imageURLToCharaterModel(url: URL) {
        print("Read data")
        var path = url.pathComponents
        path = path.filter{ $0 != "avatar"}
        guard let index = (path.last?.components(separatedBy: ".")[0]) else {
            return
        }
        path[path.endIndex - 1] = index
        var urlComp = URLComponents(string: url.absoluteString)!
        urlComp.host = url.host
        urlComp.scheme = url.scheme
        urlComp.path = path.joined(separator: "/")
        urlComp.queryItems = []
        guard let characterURL = urlComp.url else {return}
        Task {
            do {
                let character = try await CharacterLoader().loadCharacter(characterURL)
                self.characterModel = character
            } catch {
            }
        }
    }
    
    // MARK: Initializater
    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        imageURLToCharaterModel(url: model.imageURL)
    }
    
    init(characterModel: CharacterModel) {
        self.characterModel = characterModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
               }
    }
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        infoTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        infoTableView.separatorColor = .main
        view.backgroundColor = .bg
        infoTableView.delegate = self
        infoTableView.isScrollEnabled = false
        infoTableView.dataSource = self
        infoTableView.backgroundColor = .bg
        infoTableView.register(InfoTableCell.self, forCellReuseIdentifier: InfoTableCell.identifier)
        title = "Character"
        navigationController?.navigationBar.prefersLargeTitles = false
        setupUI()
        let favouriteCharacters = UserDefaults.standard.array(forKey: "Favourite characters") as? [Int]
        if favouriteCharacters == nil {
            UserDefaults.standard.set([Int](),forKey: "Favourite characters")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateRecentCharacter()
    }
    
    // MARK: Update cell info
    func updateRecentCharacter() {
        let searchRecentCharacterID = UserDefaults.standard.array(forKey: "Recent characters") as? [Int]
        guard var searchRecentCharacterID = searchRecentCharacterID else { return }
        guard let characterModel = characterModel else { return }
        searchRecentCharacterID = searchRecentCharacterID.filter { $0 != characterModel.id }
        searchRecentCharacterID.append(characterModel.id)
        if searchRecentCharacterID.count > 20 {
            searchRecentCharacterID.remove(at: 0)
        }
        let newSearchRecentCharacterID = searchRecentCharacterID
        UserDefaults.standard.set(newSearchRecentCharacterID, forKey: "Recent characters")
    }
    
    private func updateInfo() {
        guard let characterModel = characterModel else {
            return
        }
        
        icon.kf.setImage(with: characterModel.image)
        nameLabel.text = characterModel.name
        var favouriteCharacters = UserDefaults.standard.array(forKey: "Favourite characters") as? [Int]
        favouriteCharacters = UserDefaults.standard.array(forKey: "Favourite characters") as? [Int]
        if (favouriteCharacters!.contains(characterModel.id)) {
            favouriteButton.isSelected = true
        } else {
            favouriteButton.isSelected = false
        }
    }
    
    @objc func favouriteButtonAction(sender: UIButton!) {
        self.favouriteButton.isSelected = !self.favouriteButton.isSelected
        if self.favouriteButton.isSelected {
            let favouriteCharacters = UserDefaults.standard.array(forKey: "Favourite characters") as? [Int]
            var newFavouriteCharacters = favouriteCharacters
            newFavouriteCharacters?.append(characterModel!.id)
            UserDefaults.standard.set(newFavouriteCharacters, forKey: "Favourite characters")
        } else {
            let favouriteCharacters = UserDefaults.standard.array(forKey: "Favourite characters") as? [Int]
            let newFavouriteCharacters = favouriteCharacters?.filter {$0 != characterModel?.id}
            UserDefaults.standard.set(newFavouriteCharacters, forKey: "Favourite characters")
        }
    }
    
    // MARK: Set UI
    
    private func setupUI() {
        contentView.heightAnchor.constraint(equalToConstant:  800).isActive = true
        view.addSubview(scrollView)
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        scrollView.addSubview(contentView)
        
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        contentView.addSubview(infoTableView)
        contentView.addSubview(icon)
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 3
        nameAndButtonView.addSubview(nameLabel)
        nameAndButtonView.addSubview(favouriteButton)
        nameAndButtonView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(nameAndButtonView)
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        favouriteButton.setImage(UIImage(named: "Favourite_button_s")?.withTintColor(.main), for: .selected)
        favouriteButton.setImage(UIImage(named: "Favourite_button_u"), for: .normal)
        favouriteButton.tintColor = .main
        favouriteButton.addTarget(self, action: #selector(favouriteButtonAction), for: .touchUpInside)
        
        contentView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 300),
            icon.heightAnchor.constraint(equalToConstant: 300),
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            nameAndButtonView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            nameAndButtonView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            nameAndButtonView.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 35),
            infoTableView.topAnchor.constraint(equalTo: nameAndButtonView.bottomAnchor, constant: 20),
            infoTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        favouriteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        favouriteButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameAndButtonView.setContentHuggingPriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.activate([
            favouriteButton.topAnchor.constraint(equalTo: nameAndButtonView.topAnchor),
            favouriteButton.trailingAnchor.constraint(equalTo: nameAndButtonView.trailingAnchor),
            favouriteButton.bottomAnchor.constraint(lessThanOrEqualTo: nameAndButtonView.bottomAnchor),
            nameLabel.topAnchor.constraint(equalTo: nameAndButtonView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: nameAndButtonView.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: nameAndButtonView.bottomAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -16)
        ])
        nameAndButtonView.sizeToFit()
    }
}

extension CharacterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableCell.identifier, for: indexPath) as! InfoTableCell
        let infoDict: [(String,String)] = [("Status", characterModel?.status ?? "..."),("Species", characterModel?.species ?? "..."), ("Gender", characterModel?.gender ?? "...")]
        let index = indexPath.row
        cell.update(with: InfoCell.Model(key: infoDict[index].0, value: infoDict[index].1))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}


// TODO: DO did selected
extension CharacterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        super.updateViewConstraints()
    }
}
