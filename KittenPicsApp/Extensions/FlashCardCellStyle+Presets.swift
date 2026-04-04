import UIKit

// готовые пресеты дя разных категорий карточек

extension FlashCardCellStyle {
    
    static let hobbies = FlashCardCellStyle(
        gradientEng:[ UIColor.white.cgColor, UIColor.ligthLemon.cgColor], gradientDutch: [UIColor.white.cgColor, UIColor.lightOrange.cgColor],
        engLanguage: "en-US",
        dutchLanguage: "nl-NL",
        speechRate: 0.5,
        iconTintColor: .darkCyan,
        iconCornerRadius: 8,
        titleFont: .systemFont(ofSize: 16, weight: .semibold),
        titleAlignment: .center,
        iconPosition: .top,
        iconSize: .proporsional(0.65),
        soundButtonColor: .systemRed
        )
    
    static let professions = FlashCardCellStyle(
    
        gradientEng:[ UIColor.white.cgColor, UIColor.ligthLemon.cgColor], gradientDutch: [UIColor.white.cgColor, UIColor.lightOrange.cgColor],
        engLanguage: "en-US",
        dutchLanguage: "nl-NL",
        speechRate: 0.5,
        iconTintColor: .darkCyan,
        iconCornerRadius: 8,
        titleFont: .systemFont(ofSize: 16, weight: .semibold),
        titleAlignment: .center,
        iconPosition: .top,
        iconSize: .proporsional(0.65),
        soundButtonColor: .systemRed
        )
             
}

