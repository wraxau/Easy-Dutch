import UIKit

// готовые пресеты дя разных категорий карточек

extension FlashCardCellStyle {
    
    static let hobbies = FlashCardCellStyle(
        gradientEng:[ UIColor.darkBlue.cgColor, UIColor.ligthLemon.cgColor], gradientDutch: [UIColor.ligthLemon.cgColor, UIColor.lightOrange.cgColor],
        engLanguage: "en-US",
        dutchLanguage: "nl-NL",
        speechRate: 0.5,
        iconTintColor: .darkCyan,
        iconCornerRadius: 8,
        titleFont: .systemFont(ofSize: 16, weight: .semibold),
        titleAlignment: .center,
        iconPosition: .top,
        iconSize: .proporsional(0.65),
        soundButtonColor: .brightOrange
        )
    
    static let professions = FlashCardCellStyle(
    
        gradientEng:[ UIColor.ligthLemon.cgColor, UIColor.darkBlue.cgColor], gradientDutch: [UIColor.lightOrange.cgColor, UIColor.ligthLemon.cgColor],
        engLanguage: "en-US",
        dutchLanguage: "nl-NL",
        speechRate: 0.5,
        iconTintColor: .darkCyan,
        iconCornerRadius: 8,
        titleFont: .systemFont(ofSize: 16, weight: .semibold),
        titleAlignment: .center,
        iconPosition: .left,
        iconSize: .proporsional(0.65),
        spacing: Spacing(
                iconToTitle: 12,
                titleToBottom: 12,
                horizontalPadding: 12,
                verticalPadding: 8
            ),
        soundButtonColor: .brightOrange
        )
             
}

