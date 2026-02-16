import UIKit

class FoodTableViewController: UIViewController {
    
    // MARK: Constants
    
    private let dishes = [
        "Pizza 🍕", "Cheeseburger 🍔", "Pasta 🍝", "Sushi 🍣", "Tacos 🌮",
        "Cheesecake 🍰", "Brownie 🍫", "Chocolate Bar 🍫", "Ice cream 🍦",
        "Salad 🥗", "Steak 🥩", "Fried Chicken 🍗", "Hot Dog 🌭", "French Fries 🍟",
        "Shrimp 🍤", "Soup 🍲", "Ramen 🍜", "Sandwich 🥪", "Falafel 🧆", "Doughnut 🍩",
        "Croissant 🥐", "Avocado Toast 🥑", "Pancakes 🥞", "Samosa 🥟"
    ]
    
    // Заголовок с текущим выбором
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a dish"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .label
        label.backgroundColor = .systemPurple.withAlphaComponent(0.3) //прозрачность
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView = UITableView()
    
    // MARK: - Data
    
    
    private var selectedDish: String = "Choose a dish"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        
        setupStatusLabel()
        setupTableView()
        setupLayout()
    }
    
    // MARK: - Methods
    
    private func setupStatusLabel() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTableView() {
        // Регистрируем стандартную ячейку
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DishCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.alwaysBounceVertical = true
        tableView.separatorStyle = .singleLine // разделители между ячеек
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) // отступы
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        
        view.addSubview(tableView)
        view.addSubview(statusLabel)

        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            statusLabel.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
}

// MARK: - UITableViewDataSource (источник данных для таблицы)
extension FoodTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dishes.count // колво строк в таблице
    }
    // вызывается для каждой видимой и при скролле для новых
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath)
        let dish = dishes[indexPath.row]
        cell.textLabel?.text = dish
        cell.textLabel?.font = .systemFont(ofSize: 18)
        // Подсветка выбранной ячейки
        if dish == selectedDish {
            cell.backgroundColor = .systemIndigo.withAlphaComponent(0.2)
            cell.textLabel?.textColor = .systemIndigo
        } else {
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = .label
        }
        
        return cell
    }
}

extension FoodTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dish = dishes[indexPath.row]
        selectedDish = dish
        statusLabel.text = "Your choice:\n\(dish)"
        
        UIView.animate(withDuration: 0.2) {
            self.statusLabel.backgroundColor = .systemGreen.withAlphaComponent(0.4)
        } completion: { _ in
            UIView.animate(withDuration: 0.8) {
                self.statusLabel.backgroundColor = .systemYellow.withAlphaComponent(0.3)
            }
        }

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}
