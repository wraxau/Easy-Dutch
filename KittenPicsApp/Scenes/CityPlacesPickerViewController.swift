import UIKit
import SwiftUI

class CityPlacesPickerViewController: UIViewController {

    
// MARK: Constants
    // сюда будем помещать размеры элементов на экране, чтобы они все были в одном месте
    private enum Constants {
        enum TitleLabel {
            static let width: CGFloat = 100.0
        }
           
    }
    
// MARK: Subview
//- разные view которые будут лежать на нашей основнйо view - то есть элементы экрана
    
    // это реализация лямба функции котоорая сразу возаращет лейбл, который мне нужен
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's learn city vocablary in Dutch"
        label.textColor = .darkCyan
        label.numberOfLines = 0 // текст занимает столько строк, сколько ему нужно, чтобы норм помещаться
        //label.backgroundColor = .darkCyan
        label.font = .systemFont(ofSize: 22)
        label.layer.cornerRadius = 10.0
        label.clipsToBounds = true //  чтобы скругление краев background у label работало
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false // чтобы констрейнты работали для лейбла
        return label
    }()
    
    //  lazy - наш элемнт будет инициализировать не сразу, а только когда мы к нему обратимся в коде, это надо, чтобы не было утечек памяти
    private lazy var leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setTitle("Left", for: .normal)
        leftButton.setTitleColor(.ligthLemon, for: .normal)
        leftButton.backgroundColor = .darkCyan
        leftButton.layer.cornerRadius = 12  // закругление
        leftButton.clipsToBounds = true
        leftButton.addAction(
            UIAction { [weak self] _ in
                self?.showPreviousImage()
            }, for: .touchUpInside)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        return leftButton
    
    }()

    private lazy var rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.setTitle("Right", for: .normal)
        rightButton.setTitleColor(.ligthLemon, for: .normal)
        rightButton.backgroundColor = .darkCyan
        rightButton.layer.cornerRadius = 12  // закругление
        rightButton.clipsToBounds = true
        rightButton.addAction(
            UIAction { [weak self] _ in
                self?.showNextImage()
            }, for: .touchUpInside)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        return rightButton

    }()
    
    private lazy var answerButton: UIButton = {
        let answerButton = UIButton()
        answerButton.setTitle("Show answer", for: .normal)
        answerButton.setTitleColor(.ligthLemon, for: .normal)
        answerButton.backgroundColor = .darkCyan
        answerButton.layer.cornerRadius = 12  // закругление
        answerButton.clipsToBounds = true
        answerButton.addAction(
            UIAction { [weak self] _ in
                self?.showAnswer()
            }, for: .touchUpInside)
        answerButton.translatesAutoresizingMaskIntoConstraints = false
        return answerButton

    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true // изображение не будет вылезать за границы
        imageView.layer.cornerRadius = 20 // скруглила углы
        imageView.contentMode = .scaleAspectFit // изображение сохраняет свои изначальные пропорции
        imageView.image = UIImage(named: images[0])
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    
// MARK: Properties
    
    let images: [String] = ["amsterdam","bakery","beautySalon","carMechanic","clothesStore","coffeeShop","cyclingLine","flowerShop","gasStation","gym","home","hospital","hotel","kindegarden","library","office","park","pharmacy","policeOffice","postOffice","restaraunt","school","shoppingMall","street","supermarket","uni"]
    private var currentIndex = 0


// MARK: - Lifecycle
// - жизенный цикл ViewController - что когда подругжается, происходит и тд. Мы можем вызывать разные методы в разное время

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    deinit { }

//  MARK: Methods
    
    // используем Constarints а не Frame, так как Constraints адаптивные. Хотя Frame намного быстрее
    private func configureView() {
        view.backgroundColor = .ligthLemon
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1)
        ]) // отрицательные контсрейнты надо ставить, если мы ставих их к правой и нижней границе
        
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(answerButton)
        
        NSLayoutConstraint.activate([
            
            leftButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            rightButton.topAnchor.constraint(equalTo: leftButton.topAnchor),
                    
                    // Левая кнопка: отступ слева + ширина
            leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            leftButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.35),
            leftButton.heightAnchor.constraint(equalToConstant: 30), // высота
                    
                    // Правая кнопка: отступ справа + ширина = левой
            rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            rightButton.widthAnchor.constraint(equalTo: leftButton.widthAnchor),
            rightButton.heightAnchor.constraint(equalToConstant: 30),
            // расстояние между кнопками
            leftButton.trailingAnchor.constraint(lessThanOrEqualTo: rightButton.leadingAnchor, constant: -20),
            
            answerButton.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 30),
            answerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60),
            // расстояние между кнопками
            answerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60)
            
        ])
        
        
    }
    
    private func updateLabelWithEnglish(x: Int) {
        
        titleLabel.textColor = .darkCyan
        titleLabel.font = .systemFont(ofSize: 22)
        
        switch x {
        case 1:
            titleLabel.text = "Bakery"
        case 2:
            titleLabel.text = "Beauty shop"
        case 3:
            titleLabel.text = "Сar service"
        case 4:
            titleLabel.text = "Clothes shop"
        case 5:
            titleLabel.text = "Coffee shop"
        case 6:
            titleLabel.text = "Cycling line"
        case 7:
            titleLabel.text = "Flower shop"
        case 8:
            titleLabel.text = "Gas station"
        case 9:
            titleLabel.text = "Gym"
        case 10:
            titleLabel.text = "Home"
        case 11:
            titleLabel.text = "Hospital"
        case 12:
            titleLabel.text = "Hotel"
        case 13:
            titleLabel.text = "Kindegarden"
        case 14:
            titleLabel.text = "Library"
        case 15:
            titleLabel.text = "Office"
        case 16:
            titleLabel.text = "Park"
        case 17:
            titleLabel.text = "Pharmacy"
        case 18:
            titleLabel.text = "Police office"
        case 19:
            titleLabel.text = "Post office"
        case 20:
            titleLabel.text = "Restataunt"
        case 21:
            titleLabel.text = "School"
        case 22:
            titleLabel.text = "Shopping mall"
        case 23:
            titleLabel.text = "Street"
        case 24:
            titleLabel.text = "Supermarket"
        case 25:
            titleLabel.text = "University"
        default:
            titleLabel.text = "Let's learn city vocablary in Dutch"
        }
    }
    
    private func updateLabelWithAnswer(x: Int) {
        
        titleLabel.textColor = .brightOrange
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.backgroundColor = .lightOrange

        switch x {
        case 1:
            titleLabel.text = "Bakkerij"
        case 2:
            titleLabel.text = "Schoonheidssalon"
        case 3:
            titleLabel.text = "Garage"
        case 4:
            titleLabel.text = "Kledingwinkel"
        case 5:
            titleLabel.text = "Koffiebar"
        case 6:
            titleLabel.text = "Fietspad"
        case 7:
            titleLabel.text = "Bloemenwinkel"
        case 8:
            titleLabel.text = "Tankstation"
        case 9:
            titleLabel.text = "Sportschool"
        case 10:
            titleLabel.text = "Huis"
        case 11:
            titleLabel.text = "Ziekenhuis"
        case 12:
            titleLabel.text = "Hotel"
        case 13:
            titleLabel.text = "Kleuterschool"
        case 14:
            titleLabel.text = "Bibliotheek"
        case 15:
            titleLabel.text = "Kantoor"
        case 16:
            titleLabel.text = "Park"
        case 17:
            titleLabel.text = "Apotheek"
        case 18:
            titleLabel.text = "Politiebureau"
        case 19:
            titleLabel.text = "Postkantoor"
        case 20:
            titleLabel.text = "Restaurant"
        case 21:
            titleLabel.text = "School"
        case 22:
            titleLabel.text = "Winkelcentrum"
        case 23:
            titleLabel.text = "Straat"
        case 24:
            titleLabel.text = "Supermarkt"
        case 25:
            titleLabel.text = "Universiteit"
        default:
            titleLabel.text = "Let's learn city vocablary in Dutch"
        }
    }
    
    private func showNextImage() {
        currentIndex += 1
        if currentIndex >= images.count {
            currentIndex = 0
        }
        updateImage()
        updateLabelWithEnglish(x: currentIndex)
        //titleLabel.isHidden = true
    }

    private func showPreviousImage() {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = images.count - 1
        }
        updateImage()
        updateLabelWithEnglish(x: currentIndex)
        //titleLabel.isHidden = true
    }

    private func updateImage() {
        imageView.image = UIImage(named: images[currentIndex])
    }
    
    private func showAnswer() {
        updateLabelWithAnswer(x: currentIndex)
        //titleLabel.textColor = .brightOrange
        //titleLabel.isHidden = false
    }
    

}

