import AVFoundation
import UIKit

// создала базовый класс для применеия общих настроек к ячекам в UICollection - чтобы избежать дублирования кода

class FlashCardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    static let identifier: String = "FlashCardCollectionViewCell"
    
    // MARK: - Subview
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var soundButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.locations = [0.0, 1.0]
        return gradient
    }()
    
    // MARK: - Properties
    
    private var card: FlashCard?
    private var isFlipped = false
    private var style: FlashCardCellStyle?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseUI()
        setupActions()
    }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    // настройка ячейки: данные + стиль
    func configure(with card: FlashCard, style: FlashCardCellStyle) {
        self.card = card
        self.style = style
        self.isFlipped = false
        applyStyle()
        updateContent()
    }
    
    func toggleFlip() {
        guard card != nil, let style = style else { return }
        
        isFlipped.toggle()
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // анимация переворота
        
        UIView.transition(
            with: contentView,
            duration: style.flipDuration,
            options: isFlipped ? .transitionFlipFromRight : .transitionFlipFromLeft,
            animations: {[weak self] in self?.updateContent()},
            completion: nil
        )
    }
    
    // озвучить текущую сторону
    func playAudio(){
        guard let card = card, let style = style else {return}
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
                
        let text = isFlipped ? card.dutch : card.english
        let language = isFlipped ? style.dutchLanguage : style.engLanguage
                
        SpeechService.shared.speak(text: text, language: language, rate: style.speechRate)
        animateSoundButton()
        
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImageView.image = nil
        isFlipped = false
        style = nil
        contentView.transform = .identity
        contentView.alpha = 1.0
        SpeechService.shared.stop()
        
    }
    
    // MARK: - Private Methods
    private func applyStyle() {
        guard let style else {return}
        
        // Градиент
        gradientLayer.colors = style.gradientEng
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Иконка
        iconImageView.tintColor = style.iconTintColor
        iconImageView.layer.cornerRadius = style.iconCornerRadius
        iconImageView.layer.cornerCurve = .continuous
        iconImageView.contentMode = style.iconContentMode
        
        // Текст
        titleLabel.font = style.titleFont
        titleLabel.textColor = style.titleColor
        titleLabel.textAlignment = style.titleAlignment
        
        // Кнопка звука
        soundButton.tintColor = style.soundButtonColor
        soundButton.backgroundColor = style.soundButtonColor.withAlphaComponent(0.1)
        
        // Фон
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        // констрейнты
        updateConstraints(for: style)
    }
    
    private func updateConstraints(for style: FlashCardCellStyle) {
        let spacing = style.spacing
            
        switch style.iconPosition {
        case .top:
            setupTopIconLayout(spacing: spacing, iconSize: style.iconSize)
        case .left:
            setupLeftIconLayout(spacing: spacing, iconSize: style.iconSize)
        case .rigth:
            setupRightIconLayout(spacing: spacing, iconSize: style.iconSize)
        case .custom:
            setupTopIconLayout(spacing: spacing, iconSize: style.iconSize)
        }
            
            // Констрейнты кнопки звука (одинаковые для всех)
        NSLayoutConstraint.activate([
            soundButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing.verticalPadding),
            soundButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing.horizontalPadding),
            soundButton.widthAnchor.constraint(equalToConstant: 20),
            soundButton.heightAnchor.constraint(equalToConstant: 20)
            
            ])
    }
    
    private func setupTopIconLayout(spacing: FlashCardCellStyle.Spacing, iconSize: FlashCardCellStyle.IconSize) {
        let iconHeightConstraint: NSLayoutConstraint
            
        switch iconSize {
        case .proporsional(let multiplier):
            iconHeightConstraint = iconImageView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: multiplier
            )
        case .fixed(let height):
            iconHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: height)
        case .square:
            iconHeightConstraint = iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)
        }
            
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing.verticalPadding),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing.horizontalPadding),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing.horizontalPadding),
                iconHeightConstraint,
                
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: spacing.iconToTitle),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing.horizontalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing.titleToBottom)
        ])
    }
    
    private func setupLeftIconLayout(spacing: FlashCardCellStyle.Spacing, iconSize: FlashCardCellStyle.IconSize) {
        let iconWidth: CGFloat
        let iconHeight: CGFloat
            
        switch iconSize {
        case .proporsional(let multiplier):
            iconWidth = 40  // Фиксированная ширина для горизонтального лейаута
            iconHeight = 40
        case .fixed(let size):
            iconWidth = size
            iconHeight = size
        case .square:
            iconWidth = 40
            iconHeight = 40
        }
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing.horizontalPadding),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: iconWidth),
            iconImageView.heightAnchor.constraint(equalToConstant: iconHeight),
                
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: spacing.iconToTitle),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing.horizontalPadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupRightIconLayout(spacing: FlashCardCellStyle.Spacing, iconSize: FlashCardCellStyle.IconSize) {
            // Аналогично left, но зеркально
        let iconWidth: CGFloat = 40
        let iconHeight: CGFloat = 40
            
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing.horizontalPadding),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: iconWidth),
            iconImageView.heightAnchor.constraint(equalToConstant: iconHeight),
                
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -spacing.iconToTitle),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func updateContent() {
        guard let card = card, let style = style else { return }
            
            // Текст
        titleLabel.text = isFlipped ? card.dutch : card.english
            
            // Иконка
        if let symbolName = card.imageSymbol {
            iconImageView.image = UIImage(systemName: symbolName)
        } else {
            iconImageView.image = UIImage(systemName: "questionmark.circle.fill")
        }
            
            // Прозрачность иконки при перевороте
        iconImageView.alpha = isFlipped ? 0.3 : 1.0
            
            // Градиент
        gradientLayer.colors = isFlipped ? style.gradientDutch : style.gradientEng
    }
        
    private func animateSoundButton() {
        UIView.animate(withDuration: 0.2) {
            self.soundButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.soundButton.transform = .identity
            }
        }
    }
    
    private func setupBaseUI() {
        contentView.layer.insertSublayer(gradientLayer, at: 0)
            
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(soundButton)
            
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
    }
        
    private func setupActions() {
        soundButton.addTarget(self, action: #selector(soundButtonTapped), for: .touchUpInside)
    }
        
    @objc private func soundButtonTapped() {
        playAudio()
    }
        
    // MARK: - Highlight Animation
        
    override var isHighlighted: Bool {
        didSet {
            guard let style = style else { return }
            UIView.animate(withDuration: 0.1) {
                if self.isHighlighted {
                    self.contentView.transform = CGAffineTransform(
                        scaleX: style.highlightScale,
                        y: style.highlightScale
                    )
                    self.contentView.alpha = 0.8
                } else {
                    self.contentView.transform = .identity
                    self.contentView.alpha = 1.0
                }
            }
        }
    }
}
