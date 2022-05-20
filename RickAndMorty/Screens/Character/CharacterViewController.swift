import Foundation
import UIKit
import Kingfisher
import CloudKit

final class CharacterViewController: UIViewController, Sendable {
    
    struct Model {
        let imageURL: URL
    }
    
    var characterModel: CharacterModel? {
        didSet {
            DispatchQueue.main.async { [self] in
                updateInfo()
            }
        }
    }
    
    let favouriteButton = UIButton()
    
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
                if let character = try await CharacterLoader().loadCharacter(characterURL) {
                    self.characterModel = character
                }
            } catch {
            }
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bg
        title = "Character"
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
    
    
    private func setupUI() {
        view.addSubview(icon)
        view.addSubview(infoCell)
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 3
        let nameAndButtonView = UIView()
        nameAndButtonView.addSubview(nameLabel)
        nameAndButtonView.addSubview(favouriteButton)
        nameAndButtonView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(nameAndButtonView)
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        favouriteButton.setImage(UIImage(named: "Favourite_button_s")?.withTintColor(.main), for: .selected)
        favouriteButton.setImage(UIImage(named: "Favourite_button_u"), for: .normal)
        favouriteButton.tintColor = .main
        favouriteButton.addTarget(self, action: #selector(favouriteButtonAction), for: .touchUpInside)
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 300),
            icon.heightAnchor.constraint(equalToConstant: 300),
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameAndButtonView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameAndButtonView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameAndButtonView.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 35),
            infoCell.topAnchor.constraint(equalTo: nameAndButtonView.bottomAnchor, constant: 20),
            infoCell.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infoCell.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
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
    
    private func updateInfo() {
        guard let characterModel = characterModel else {
            return
        }
        
        icon.kf.setImage(with: characterModel.image)
        nameLabel.text = characterModel.name
        infoCell.update(with: InfoCell.Model(key: "Status", value: characterModel.status ))
        var favouriteCharacters = UserDefaults.standard.array(forKey: "Favourite characters") as? [Int]
        favouriteCharacters = UserDefaults.standard.array(forKey: "Favourite characters") as? [Int]
        if (favouriteCharacters!.contains(characterModel.id)) {
            favouriteButton.isSelected = true
        } else {
            favouriteButton.isSelected = false
        }
    }
    
    private var model: Model? = nil
    
    private lazy var icon: UIImageView = {
        let ret = UIImageView()
        ret.layer.cornerRadius = 10
        ret.layer.masksToBounds = true
        ret.contentMode = .scaleAspectFill
        return ret
    }()
    
    private lazy var nameLabel: UILabel = {
        let ret = UILabel()
        ret.font = .boldSystemFont(ofSize: 34)
        ret.textColor = .main
        return ret
    }()
    
    private lazy var infoCell = InfoCell()
}
