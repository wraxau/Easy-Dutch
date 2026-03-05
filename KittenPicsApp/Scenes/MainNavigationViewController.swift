import Foundation
import SwiftUI
import UIKit

class MainNavigationViewController: UIViewController {
    
    // MARK: Constants
    
    
    // MARK: Subview
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Menu"
        label.textColor = .darkBlue
        label.font = .boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.layer.masksToBounds = false
        label.textAlignment = .center // центрирую текст в области, которую задам по label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cityButton: UIButton = {
        let button = UIButton()
        button.setTitle("Places in the City", for: .normal)
        button.applyStyle()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction( // обработчик нажатия на кнопку
            UIAction{ [weak self] _ in
                self?.openCityage()
            }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var animalsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Animals", for: .normal)
        button.applyStyle()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(
            UIAction{ [weak self] _ in
                self?.openAnimalsPage()
            }, for: .touchUpInside)
        return button
    }()
    
    private lazy var uikitTableButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Food", for: .normal)
        button.applyStyle()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(
            UIAction{ [weak self] _ in
                self?.openUIKitPage()
            }, for: .touchUpInside)
        return button
    }()
    
    private lazy var swiftuiTableButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Drinks", for: .normal)
        button.applyStyle()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(
            UIAction{ [weak self] _ in
                self?.openSwiftUIPage()
            }, for: .touchUpInside)
        return button
    }()
    
    private lazy var uiCollectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Netherlands", for: .normal)
        button.applyStyle()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(
            UIAction{ [weak self] _ in
                self?.openUICollectionPage()
            }, for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Properties
    
    // MARK: - Lifecycle
    // - жизенный цикл ViewController - что когда подругжается, происходит и тд. Мы можем вызывать разные методы в разное время
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    deinit { }
    
    //  MARK: Methods
    
    private func configureView() {
        view.backgroundColor = .ligthLemon
        
        [titleLabel, cityButton, animalsButton, uikitTableButton, swiftuiTableButton, uiCollectionButton].forEach {
            view.addSubview($0) // добавила сразу все элементы
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            //titleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            cityButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            cityButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cityButton.widthAnchor.constraint(equalToConstant: 300),
            cityButton.heightAnchor.constraint(equalToConstant: 60),
            
            animalsButton.topAnchor.constraint(equalTo: cityButton.bottomAnchor, constant: 30),
            animalsButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            animalsButton.widthAnchor.constraint(equalToConstant: 300),
            animalsButton.heightAnchor.constraint(equalToConstant: 60),
            
            uikitTableButton.topAnchor.constraint(equalTo: animalsButton.bottomAnchor, constant: 30),
            uikitTableButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            uikitTableButton.widthAnchor.constraint(equalToConstant: 300),
            uikitTableButton.heightAnchor.constraint(equalToConstant: 60),
            
            swiftuiTableButton.topAnchor.constraint(equalTo: uikitTableButton.bottomAnchor, constant: 30),
            swiftuiTableButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            swiftuiTableButton.widthAnchor.constraint(equalToConstant: 300),
            swiftuiTableButton.heightAnchor.constraint(equalToConstant: 60),
            
            uiCollectionButton.topAnchor.constraint(equalTo: swiftuiTableButton.bottomAnchor, constant: 30),
            uiCollectionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            uiCollectionButton.widthAnchor.constraint(equalToConstant: 300),
            uiCollectionButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
        
    }
    
    private func openCityage() {
        let cityPlacesVC = CityPlacesPickerViewController()
        cityPlacesVC.title = "Places in the City"
        navigationController?.pushViewController(cityPlacesVC, animated: true)
    }
    private func openAnimalsPage() {
        let animalsView = AnimalsPickerView() {  // замыкание для возврата
            self.navigationController?.popViewController(animated: true)
        }
        
        let hostingController = UIHostingController(rootView: animalsView) //это SwiftUI View (struct), а не UIViewController поэтому нужно обернуть в UIHostingController
        hostingController.title = "Animals"
        
        navigationController?.pushViewController(hostingController, animated: true)
    }

    private func openUIKitPage() {
        let tableVC = FoodTableViewController()
        tableVC.title = "Food"
        navigationController?.pushViewController(tableVC, animated: true)
    }
    
    private func openSwiftUIPage() {
        let swiftUIView =  DrinkViewList {
            self.navigationController?.popViewController(animated: true)
        }
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.title = "Drinks"
        
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    private func openUICollectionPage() {
        let tableVC = UICollectionViewController()
        tableVC.title = "Netherlands"
        navigationController?.pushViewController(tableVC, animated: true)
    }
    
}
    
