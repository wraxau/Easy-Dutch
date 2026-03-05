import Foundation
import UIKit

// стиль кнопок для mainNavigator, чтобы там код не дублировать
extension UIButton {
    
    func applyStyle() {
        titleLabel?.font = .systemFont(ofSize: 16)
        backgroundColor = .darkBlue
        setTitleColor(.ligthLemon, for: .normal)
        layer.cornerRadius = 20
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
    }
}
