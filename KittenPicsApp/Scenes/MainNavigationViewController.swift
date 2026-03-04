import Foundation
import SwiftUI
import UIKit

class MainNavigationViewController: UIViewController {
    
    // MARK: Constants
    
    
    // MARK: Subview
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Main control screen"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 8
        label.layer.shadowOpacity = 0.6
        label.layer.masksToBounds = false
        label.textAlignment = .center // центрирую текст в области, которую задам по label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var catButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cats", for: .normal)
        button.applyStyle()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction( // обработчик нажатия на кнопку
            UIAction{ [weak self] _ in
                self?.openCatPage()
            }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var dogButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dogs", for: .normal)
        button.applyStyle()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(
            UIAction{ [weak self] _ in
                self?.openDogPage()
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
        view.backgroundColor = .systemIndigo
        
        [titleLabel, catButton, dogButton, uikitTableButton, swiftuiTableButton, uiCollectionButton].forEach {
            view.addSubview($0) // добавила сразу все элементы
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            //titleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            catButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            catButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            catButton.widthAnchor.constraint(equalToConstant: 300),
            catButton.heightAnchor.constraint(equalToConstant: 60),
            
            dogButton.topAnchor.constraint(equalTo: catButton.bottomAnchor, constant: 30),
            dogButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            dogButton.widthAnchor.constraint(equalToConstant: 300),
            dogButton.heightAnchor.constraint(equalToConstant: 60),
            
            uikitTableButton.topAnchor.constraint(equalTo: dogButton.bottomAnchor, constant: 30),
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
    
    private func openCatPage() {
        let catVC = CatsPickerViewController()
        catVC.title = "Cats"
        navigationController?.pushViewController(catVC, animated: true)
    }
    private func openDogPage() {
        let dogView = DogsPickerView() {  // замыкание для возврата
            self.navigationController?.popViewController(animated: true)
        }
        
        let hostingController = UIHostingController(rootView: dogView) //это SwiftUI View (struct), а не UIViewController поэтому нужно обернуть в UIHostingController
        hostingController.title = "Dogs"
        
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
    
