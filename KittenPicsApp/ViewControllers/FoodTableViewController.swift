import UIKit

class FoodTableViewController: UIViewController {

    // MARK: Constants

    private let dishes = [
        "Chocolate bar 🍫", "Ice cream 🍦",
        "Salad 🥗", "Beef steak 🥩", "Fried chicken 🍗", "Hot dog 🌭", "French fries 🍟",
        "Shrimp 🍤", "Soup 🍲", "Ramen 🍜", "Sandwich 🥪", "Falafel 🧆", "Donut 🍩",
        "Croissant 🥐", "Avocado toast 🥑", "Pancakes 🥞",
        "Lasagne 🍲", "Paella 🥘", "Kebab 🥙", "Pizza Margherita 🍕", "Curry 🍛",
        "Fish and chips 🐟🍟", "Schnitzel 🍖", "Waffles 🧇", "Apple pie 🥧",
        "Crêpe 🥞", "Hummus 🫘", "Risotto 🍚", "Burrito 🌯", "Chili con carne 🌶️",
        "Goulash 🍲", "Moussaka 🫕", "Quiche 🥧", "Tapas 🫙", "Omelet 🍳", "Bagel 🥯"
    ]

    private let dishesNL = [
        "Chocoladereep 🍫", "IJs 🍦", "Salade 🥗", "Biefstuk 🥩",
        "Gebakken kip 🍗", "Hotdog 🌭", "Frietjes 🍟", "Garnaal 🍤",
        "Soep 🍲", "Ramen 🍜", "Broodje 🥪", "Falafel 🧆", "Donut 🍩",
        "Croissant 🥐", "Avocado toast 🥑", "Pannenkoeken 🥞",
        "Lasagne 🍲", "Paella 🥘", "Kebab 🥙", "Pizza Margherita 🍕",
        "Curry 🍛", "Vis met friet 🐟🍟", "Schnitzel 🍖", "Wafels 🧇",
        "Appeltaart 🥧", "Crêpe 🥞", "Hummus 🫘", "Risotto 🍚", "Burrito 🌯",
        "Chili con carne 🌶️", "Goulash 🍲", "Moussaka 🫕", "Quiche 🥧", "Tapas 🫙",
        "Omelet 🍳", "Bagel 🥯"
    ]

    private let yourChoiceLabel: UILabel = {
        let label = UILabel()
        label.text = "Your choice"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let selectionCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Заголовок с текущим выбором
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a dish"
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .darkBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Data

    private var selectedDish: String = ""

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupTableView()
        setupLayout()
    }

    // MARK: - Methods

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
        selectionCardView.addSubview(statusLabel)

        view.addSubview(yourChoiceLabel)
        view.addSubview(selectionCardView)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            yourChoiceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            yourChoiceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            yourChoiceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            selectionCardView.topAnchor.constraint(equalTo: yourChoiceLabel.bottomAnchor, constant: 8),
            selectionCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            selectionCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            statusLabel.topAnchor.constraint(equalTo: selectionCardView.topAnchor, constant: 16),
            statusLabel.bottomAnchor.constraint(equalTo: selectionCardView.bottomAnchor, constant: -16),
            statusLabel.leadingAnchor.constraint(equalTo: selectionCardView.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: selectionCardView.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: selectionCardView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        cell.textLabel?.font = .systemFont(ofSize: 25)
        cell.textLabel?.textColor = .darkCyan
        // Подсветка выбранной ячейки
        if dish == selectedDish {
            cell.backgroundColor = UIColor.darkBlue.withAlphaComponent(0.08)
            let checkmark = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
            checkmark.tintColor = .darkBlue
            checkmark.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            cell.accessoryView = checkmark
        } else {
            cell.backgroundColor = .clear
            cell.accessoryView = nil
        }

        return cell
    }
}

extension FoodTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < dishesNL.count {
            statusLabel.text = dishesNL[indexPath.row]
            selectedDish = dishes[indexPath.row]
        }

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}
