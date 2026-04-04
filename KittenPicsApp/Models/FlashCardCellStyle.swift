// Стиль ячеек в UICollection
import UIKit

struct FlashCardCellStyle {
    
    // цве карточек(градиенты)
    let gradientEng: [CGColor]          // для лицевой стороны карточки
    let gradientDutch: [CGColor]         // для обратной стороны карточки
    
    // настройка озвучки
    let engLanguage: String
    let dutchLanguage: String
    let speechRate: Float     // скорость речи
    
    // настройки текста
    let iconTintColor: UIColor
    let iconCornerRadius: CGFloat
    let iconContentMode: UIView.ContentMode
    
    // настройка текста
    let titleFont: UIFont
    let titleColor: UIColor
    let titleAlignment: NSTextAlignment
    let subtitleFont: UIFont?
    
    // настройка констрейнтов
    let iconPosition: IconPosition
    let iconSize: IconSize
    let spacing: Spacing
    
    // кнопка звука
    let soundButtonColor: UIColor
    let soundButtonSize: CGFloat
    
    // анимация
    let flipDuration: TimeInterval
    let highlightScale: CGFloat
    
    // MARK: - init
    
    init(
        gradientEng: [CGColor],
        gradientDutch: [CGColor],
        engLanguage: String = "en-US",
        dutchLanguage: String = "nl-NL",
        speechRate: Float = 0.5,
        iconTintColor: UIColor = .darkCyan,
        iconCornerRadius: CGFloat = 8,
        iconContentMode: UIView.ContentMode = .scaleAspectFit,
        titleFont: UIFont = .systemFont(ofSize: 16, weight: .semibold),
        titleColor: UIColor = .darkCyan,
        titleAlignment: NSTextAlignment = .center,
        subtitleFont: UIFont? = nil,
        iconPosition: IconPosition = .top,
        iconSize: IconSize = .proporsional(0.65),
        spacing: Spacing = .default,
        soundButtonColor: UIColor = .systemRed,
        soundButtonSize: CGFloat = 10,
        flipDuration: TimeInterval = 0.4,
        highlightScale: CGFloat = 0.95
    ) {
        self.gradientEng = gradientEng
        self.gradientDutch = gradientDutch
        self.engLanguage = engLanguage
        self.dutchLanguage = dutchLanguage
        self.speechRate = speechRate
        self.iconTintColor = iconTintColor
        self.iconCornerRadius = iconCornerRadius
        self.iconContentMode = iconContentMode
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.titleAlignment = titleAlignment
        self.subtitleFont = subtitleFont
        self.iconPosition = iconPosition
        self.iconSize = iconSize
        self.spacing = spacing
        self.soundButtonColor = soundButtonColor
        self.soundButtonSize = soundButtonSize
        self.flipDuration = flipDuration
        self.highlightScale = highlightScale
    }

    enum IconPosition {
        case top
        case left
        case rigth
        case custom
    }

    enum IconSize {
        case proporsional (CGFloat)
        case fixed (CGFloat)
        case square
    }
    
    struct Spacing {
        let iconToTitle: CGFloat
        let titleToBottom: CGFloat
        let horizontalPadding: CGFloat
        let verticalPadding: CGFloat
            
        static let `default` = Spacing(
            iconToTitle: 8,
            titleToBottom: 8,
            horizontalPadding: 8,
            verticalPadding: 8
        )
    }
    
    
}
