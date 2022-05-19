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
        updateInfo()
    }
    
    private func setupUI() {
        view.addSubview(icon)
        view.addSubview(nameLabel)
        view.addSubview(infoCell)
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 300),
            icon.heightAnchor.constraint(equalToConstant: 300),
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infoCell.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            infoCell.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            infoCell.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateInfo() {
        icon.kf.setImage(with: characterModel?.image)
        //icon.kf.setImage(with: model.imageURL)
        nameLabel.text = characterModel?.name
        infoCell.update(with: InfoCell.Model(key: "Status", value: characterModel?.status ?? "..."))
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
        ret.numberOfLines = 1
        ret.textColor = .main
        return ret
    }()
    
    private lazy var infoCell = InfoCell()
}
