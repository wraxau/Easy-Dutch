import UIKit
import Foundation

final class SouthHollandCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "SouthHollandCollectionViewCell"
    
    // MARK: - Subview
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    // MARK: - Configure
    
    func configure (with city: String) {
        titleLabel.text = city
        contentView.backgroundColor = .lightGray
    }
    
    // MARK: - UI
    private func configureUI() {
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}

