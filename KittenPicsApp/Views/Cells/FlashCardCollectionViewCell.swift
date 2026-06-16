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

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var soundButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "speaker.wave.2.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        return button
    }()

    // MARK: - Glass Effect

    private let blurView: UIVisualEffectView = {
        UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
    }()

    private let tintOverlayView = UIView()

    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.locations = [0.0, 1.0]
        gradient.opacity = 0.28
        return gradient
    }()

    // MARK: - Properties

    private var card: FlashCard?
    private var isFlipped = false
    private var style: FlashCardCellStyle?
    // MARK: tracks active layout constraints to avoid accumulation on reuse
    private var activeLayoutConstraints: [NSLayoutConstraint] = []

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
            animations: { [weak self] in self?.updateContent() },
            completion: nil
        )
    }

    // озвучить текущую сторону
    func playAudio() {
        guard let card = card, let style = style else { return }

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
        blurView.frame = contentView.bounds
        tintOverlayView.frame = contentView.bounds
        gradientLayer.frame = tintOverlayView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImageView.image = nil
        isFlipped = false
        style = nil
        contentView.transform = .identity
        contentView.alpha = 1.0
        NSLayoutConstraint.deactivate(activeLayoutConstraints)
        activeLayoutConstraints = []
        SpeechService.shared.stop()
    }

    // MARK: - Private Methods

    private func applyStyle() {
        guard let style else { return }

        // Градиент
        gradientLayer.colors = style.gradientEng

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
        contentView.layer.masksToBounds = true

        // констрейнты
        updateConstraints(for: style)
    }

    private func updateConstraints(for style: FlashCardCellStyle) {
        NSLayoutConstraint.deactivate(activeLayoutConstraints)

        let spacing = style.spacing
        var constraints: [NSLayoutConstraint]

        switch style.iconPosition {
        case .top, .custom:
            constraints = makeTopIconConstraints(spacing: spacing, iconSize: style.iconSize)
        case .left:
            constraints = makeLeftIconConstraints(spacing: spacing, iconSize: style.iconSize)
        case .rigth:
            constraints = makeRightIconConstraints(spacing: spacing, iconSize: style.iconSize)
        }

        // MARK: sound button constraints — same for all layouts
        constraints += [
            soundButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            soundButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12),
            soundButton.widthAnchor.constraint(equalToConstant: 20),
            soundButton.heightAnchor.constraint(equalToConstant: 20)
        ]

        NSLayoutConstraint.activate(constraints)
        activeLayoutConstraints = constraints
    }

    private func makeTopIconConstraints(spacing: FlashCardCellStyle.Spacing, iconSize: FlashCardCellStyle.IconSize) -> [NSLayoutConstraint] {
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

        return [
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing.verticalPadding),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing.horizontalPadding),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing.horizontalPadding),
            iconHeightConstraint,
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: spacing.iconToTitle),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing.horizontalPadding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing.titleToBottom)
        ]
    }

    private func makeLeftIconConstraints(spacing: FlashCardCellStyle.Spacing, iconSize: FlashCardCellStyle.IconSize) -> [NSLayoutConstraint] {
        let side: CGFloat
        switch iconSize {
        case .fixed(let size): side = size
        default:               side = 40
        }
        return [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing.horizontalPadding),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: side),
            iconImageView.heightAnchor.constraint(equalToConstant: side),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: spacing.iconToTitle),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing.horizontalPadding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
    }

    private func makeRightIconConstraints(spacing: FlashCardCellStyle.Spacing, iconSize: FlashCardCellStyle.IconSize) -> [NSLayoutConstraint] {
        // MARK: mirrors makeLeftIconConstraints
        return [
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing.horizontalPadding),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -spacing.iconToTitle),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
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
        // MARK: - Glass layer order: blur → tint → content
        tintOverlayView.layer.insertSublayer(gradientLayer, at: 0)

        contentView.addSubview(blurView)
        contentView.addSubview(tintOverlayView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(soundButton)

        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor

        layer.shadowColor = UIColor.darkBlue.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
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
