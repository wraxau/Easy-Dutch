import Foundation
import UIKit

// стиль кнопок для mainNavigator, чтобы там код не дублировать
extension UIButton {
    
    func applyStyle() {
        titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        backgroundColor = .darkBlue.withAlphaComponent(0.8)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 15
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
    }
}
extension UIButton {
    
    func applyStyleForBigButtons() {
        titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        backgroundColor = .darkBlue.withAlphaComponent(0.8)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 28
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
    }
}
