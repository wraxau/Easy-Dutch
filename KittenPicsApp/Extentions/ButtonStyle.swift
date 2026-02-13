import Foundation
import UIKit

// стиль кнопок для mainNavigator, чтобы там код не дублировать
extension UIButton {
    
    func applyStyle() {
        titleLabel?.font = .systemFont(ofSize: 16)
        backgroundColor = .systemGray2
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 20
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowRadius = 8
        layer.shadowColor = UIColor.black.cgColor
    }
}
