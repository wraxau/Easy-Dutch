import UIKit
import SwiftUI

// MARK: - CategoryCardCell

private final class CategoryCardCell: UICollectionViewCell {

    static let identifier = "CategoryCardCell"

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10

        contentView.layer.cornerRadius = 20
        contentView.layer.cornerCurve = .continuous
        contentView.layer.masksToBounds = true

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -18),
            iconImageView.widthAnchor.constraint(equalToConstant: 52),
            iconImageView.heightAnchor.constraint(equalToConstant: 52),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, icon: String, color: UIColor) {
        titleLabel.text = title
        titleLabel.textColor = color
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = color
        contentView.backgroundColor = color.withAlphaComponent(0.1)
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.12, delay: 0, options: [.allowUserInteraction]) {
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.95, y: 0.95)
                    : .identity
                self.alpha = self.isHighlighted ? 0.85 : 1.0
            }
        }
    }
}

// MARK: - CategoriesViewController

final class CategoriesViewController: UIViewController {

    // MARK: - Data

    private struct Category {
        let title: String
        let icon: String
        let color: UIColor
    }

    private let categories: [Category] = [
        Category(title: "Places in the City", icon: "building.2.fill",  color: .darkBlue),
        Category(title: "Animals",            icon: "pawprint.fill",     color: .darkBlue),
        Category(title: "Food",               icon: "fork.knife",        color: .darkBlue),
        Category(title: "Basic Phrases",      icon: "text.bubble.fill",  color: .darkBlue),
        Category(title: "Colors",             icon: "paintpalette.fill", color: .darkBlue),
        Category(title: "Numbers",            icon: "textformat.123",    color: .darkBlue),
        Category(title: "Daily Routine",      icon: "sun.horizon.fill",  color: .darkBlue),
        Category(title: "Shopping",           icon: "bag.fill",          color: .darkBlue)
    ]

    // MARK: - Subview

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 20, bottom: 20, right: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CategoryCardCell.self, forCellWithReuseIdentifier: CategoryCardCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Navigation

    private func openCity() {
        let vc = CityPlacesPickerViewController()
        vc.title = "Places in the City"
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openAnimals() {
        let animalsView = AnimalsPickerView {
            self.navigationController?.popViewController(animated: true)
        }
        let hostingVC = UIHostingController(rootView: animalsView)
        hostingVC.title = "Animals"
        navigationController?.pushViewController(hostingVC, animated: true)
    }

    private func openFood() {
        let vc = FoodTableViewController()
        vc.title = "Food"
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openPhrases() {
        let phrasesView = BasicPhrasesViewList {
            self.navigationController?.popViewController(animated: true)
        }
        let hostingVC = UIHostingController(rootView: phrasesView)
        hostingVC.title = "Basic Phrases"
        navigationController?.pushViewController(hostingVC, animated: true)
    }

    private func openColors() {
        let colorsView = ColorsVocabView {
            self.navigationController?.popViewController(animated: true)
        }
        let hostingVC = UIHostingController(rootView: colorsView)
        hostingVC.title = "Colors"
        navigationController?.pushViewController(hostingVC, animated: true)
    }

    private func openNumbers() {
        let numbersView = NumbersVocabView {
            self.navigationController?.popViewController(animated: true)
        }
        let hostingVC = UIHostingController(rootView: numbersView)
        hostingVC.title = "Numbers"
        navigationController?.pushViewController(hostingVC, animated: true)
    }

    private func openDailyRoutine() {
        let routineView = DailyRoutineVocabView {
            self.navigationController?.popViewController(animated: true)
        }
        let hostingVC = UIHostingController(rootView: routineView)
        hostingVC.title = "Daily Routine"
        navigationController?.pushViewController(hostingVC, animated: true)
    }

    private func openShopping() {
        let shoppingView = ShoppingVocabView {
            self.navigationController?.popViewController(animated: true)
        }
        let hostingVC = UIHostingController(rootView: shoppingView)
        hostingVC.title = "Shopping"
        navigationController?.pushViewController(hostingVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCardCell.identifier, for: indexPath
        ) as? CategoryCardCell else {
            return UICollectionViewCell()
        }
        let cat = categories[indexPath.item]
        cell.configure(title: cat.title, icon: cat.icon, color: cat.color)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoriesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0: openCity()
        case 1: openAnimals()
        case 2: openFood()
        case 3: openPhrases()
        case 4: openColors()
        case 5: openNumbers()
        case 6: openDailyRoutine()
        case 7: openShopping()
        default: break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16
        let inset: CGFloat = 20
        let available = collectionView.bounds.width - inset * 2 - spacing
        let side = floor(available / 2)
        return CGSize(width: side, height: side)
    }
}
