import UIKit
import SwiftUI

extension UIColor {

    // задала computed property, так как в extension нельзя создавать stored
        static var brightOrange: UIColor {
            UIColor(red: 255/255.0, green: 107/255.0, blue: 53/255.0, alpha: 1.0)
        }
        
        static var lightOrange: UIColor {
            UIColor(red: 247/255.0, green: 197/255.0, blue: 159/255.0, alpha: 1.0)
        }
        
        static var ligthLemon: UIColor {
            UIColor(red: 247/255.0, green: 225/255.0, blue: 198/255.0, alpha: 1.0)
        }
        
        static var darkBlue: UIColor {
            UIColor(red: 0/255.0, green: 78/255.0, blue: 137/255.0, alpha: 1.0)
        }
        
        static var darkCyan: UIColor {
            UIColor(red: 26/255.0, green: 101/255.0, blue: 158/255.0, alpha: 1.0)
        }
}


// чтобы в swiftui файлах тоже работало
extension Color {
    static var ligthLemon: Color { Color(UIColor.ligthLemon) }
    static var lightOrange: Color { Color(UIColor.lightOrange) }
    static var brightOrange: Color { Color(UIColor.brightOrange) }
    static var darkBlue: Color { Color(UIColor.darkBlue) }
    static var darkCyan: Color { Color(UIColor.darkCyan) }

}


