import UIKit

final class InfoTableCell: UITableViewCell {
    
    static let identifier: String = "InfoTableCell"
    
    let infoCell = InfoCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .bg
        self.contentView.backgroundColor = .bg
        self.selectionStyle = .none
        setUp()
    }
    
    func update(with model: InfoCell.Model) {
        infoCell.update(with: model)
    }
    
    func setUp() {
        contentView.addSubview(infoCell)
        infoCell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            infoCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            infoCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class InfoCell: UIView {

    struct Model {
        let key: String
        let value: String
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with model: Model) {
        infoKeyLabel.text = model.key
        infoValueLabel.text = model.value
    }

    private func setup() {
        let stack = UIStackView()
        addSubview(stack)
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.contentMode = .left
        stack.axis = .vertical
        stack.spacing = 0

        stack.addArrangedSubview(infoKeyLabel)
        stack.addArrangedSubview(infoValueLabel)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

    private lazy var infoKeyLabel: UILabel = {
        let ret = UILabel()
        ret.font = .boldSystemFont(ofSize: 22)
        ret.textColor = .secondary
        ret.numberOfLines = 1
        return ret
    }()

    private lazy var infoValueLabel: UILabel = {
        let ret = UILabel()
        ret.font = .boldSystemFont(ofSize: 22)
        ret.textColor = .main
        ret.numberOfLines = 1
        return ret
    }()
}

