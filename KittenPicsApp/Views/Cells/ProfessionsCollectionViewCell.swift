import UIKit
import Foundation

final class ProfessionsCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "ProfessionsCollectionViewCell"
    private var card: FlashCard?        // Храним карточку
    private var isFlipped = false       // Состояние: перевернута или нет
    
    // MARK: - Subview
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let professionImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        imageView.layer.cornerRadius = 8
        imageView.layer.cornerCurve = .continuous
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .darkCyan.withAlphaComponent(0.2)
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) { // создание ячеек
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // если вдруг этот метод вызовется, то приложение упадет с ошибкой
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() { // чистка ячейки, если нам надо показать ячейку с какими-то обновленными данными
        super.prepareForReuse()
        titleLabel.text = nil
        professionImageView.image = nil
        isFlipped = false
    }
    
    // MARK: - Configure
    
    func configure(with card: FlashCard) {
        
        self.card = card
        isFlipped = false
        titleLabel.text = card.english
        
        // Установка иконки с запасным вариантом
        if let symbolName = card.imageSymbol {
            professionImageView.image = UIImage(systemName: symbolName)
            professionImageView.tintColor = .darkCyan
        } else {
            professionImageView.image = UIImage(systemName: "questionmark.circle.fill")
        }
    }
    
    private func setupUI() {
        contentView.addSubview(professionImageView)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = UIColor.ligthLemon.withAlphaComponent(0.4)
        contentView.layer.cornerRadius = 8
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
            
        NSLayoutConstraint.activate([
        professionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
        professionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        professionImageView.widthAnchor.constraint(equalToConstant: 40),
        professionImageView.heightAnchor.constraint(equalToConstant: 40),
                
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
        titleLabel.leadingAnchor.constraint(equalTo: professionImageView.trailingAnchor, constant: 12),
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])
        }
    
    // MARK: - Animation
    func toggleFlip() {
        guard card != nil else { return }
            
        isFlipped.toggle()
            
        // Вибрация при нажатии
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
            
        // Анимация переворота
        UIView.transition(
            with: contentView,
            duration: 0.4,
            options: isFlipped ? .transitionFlipFromRight : .transitionFlipFromLeft,
            animations: { [weak self] in
                self?.updateUI()
            },
            completion: nil
        )
    }
    
    private func updateUI() {
            guard let card = card else { return }
            
            if isFlipped {
                // Голландская сторона
                titleLabel.text = card.dutch
                professionImageView.alpha = 1.0
                contentView.backgroundColor = UIColor.darkBlue.withAlphaComponent(0.1)
            } else {
                // Английская сторона
                titleLabel.text = card.english
                professionImageView.alpha = 1.0
                contentView.backgroundColor = UIColor.ligthLemon.withAlphaComponent(0.5)

            }
            
        }
}

