import Foundation
import UIKit

final class UICollectionViewController: UIViewController {
    
    // MARK: - Setions
    
    private enum CollectionSectionType: Int, CaseIterable {
        case hobbies
        case professions
    }
    
    // MARK: - Constants
    
    private enum Constant {
        static let itemPerRow: CGFloat = 2 // вот тут можем спокойно менять, поскольку у нас в extention прописаны все рассчеты и мы можем тут указать любое количество элементов в строке какое нам необходимо
        static let minimumLineSpacingForSection: CGFloat = 10.0
        static let minimumInteritemSpacingForSection: CGFloat = 10.0
        static let insetForSection: UIEdgeInsets = .init(top: 24, left: 16, bottom: 24, right: 16)
    }
    
    // MARK:  Properties
    
    
    // MARK: - Subview
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout() // создае layout чтобы потом его проинициализировать в коллекции
        // вот тут если что можем переписать какие-то кастомные настрйоки для нашего layout, если нам надо
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout) // стандартный инициализатор для коллекции
        collection.delegate = self // viewController делегирует все события из коллекции(скролл, нажатия на ячейки)
        collection.dataSource = self
        collection.register(HobbiesCollectionViewCell.self, forCellWithReuseIdentifier: HobbiesCollectionViewCell.identifier)
        collection.register(ProfessionsCollectionViewCell.self, forCellWithReuseIdentifier: ProfessionsCollectionViewCell.identifier)
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
    }
    
    // MARK: - Methods
    
    private func configureUI() {
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}

// MARK: - Delegate

extension UICollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = CollectionSectionType(rawValue: indexPath.section) else { return }
        
        //Найти ячейку и вызвать анимацию
        if let cell = collectionView.cellForItem(at: indexPath) {
            switch section {
            case .hobbies:
                (cell as? HobbiesCollectionViewCell)?.toggleFlip()
            case .professions:
                (cell as? ProfessionsCollectionViewCell)?.toggleFlip()
            }
        }
    }
}

// MARK: - Data Source

extension UICollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CollectionSectionType.allCases.count
    } // возвращаем количество элементов в секции
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = CollectionSectionType(rawValue: section) else {
            return 0
        }
        
        // при такой реализации легко отловаить ошибки, если у нас добавится новая секция, то тут сразц вылезет ошибка и мы поймем, что ее надо добавить сюда в enum. Если бы мы делали через if section ==0 и тд, то у нас бы тут не вылезала ошибка, и нам было бы сложнее ее отловить
        
        switch section {
        case .hobbies:
            return FlashCard.hobbies.count
        case .professions:
            return FlashCard.professions.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = CollectionSectionType(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section { // создаем ячейку
        case .hobbies:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HobbiesCollectionViewCell.identifier, for: indexPath
            ) as? HobbiesCollectionViewCell else { return UICollectionViewCell() }
            
             // после того, как проверили, что это нужная ячейка - вызываем метод конфигурации этой ячейки
            let card = FlashCard.hobbies[indexPath.row]
            cell.configure(with: card)
            return cell
            
        case .professions:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfessionsCollectionViewCell.identifier, for: indexPath
            ) as? ProfessionsCollectionViewCell else { return UICollectionViewCell() }
            let card = FlashCard.professions[indexPath.row]
            cell.configure(with: card)
            return cell
        }
    }
}

// MARK: - FlowLayout

// лучше все натсрйоки layout задавать вот тут
extension UICollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constant.minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constant.minimumInteritemSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let section = CollectionSectionType(rawValue: indexPath.section) else {
            return CGSize()
        }
        
        switch section {
        case .hobbies:
            let itemPerRow = Constant.itemPerRow //  сколько элементов на одну строчку
            let insets = Constant.insetForSection // insert справа, слева, сверху и снизу делаем отступы
            let spacing = Constant.minimumInteritemSpacingForSection // расстояние между items
            // тут высчитываем, какая у нас доступна ширина для одного элемента, учитывая все отступы
            let availableWidth = collectionView.bounds.width - insets.left - insets.right - spacing * (itemPerRow - 1)
            //  и высчитываем нужную ширину для элемента
            let itemWidth = floor(availableWidth / itemPerRow)
            return CGSize(width: itemWidth, height: itemWidth) // если мы тут захардкодим, что, например, item должны быть строго 200 на 200, но при этом у нас в enum в константах указано, что должно быть 3 элемента в ряд - а они не будут влезать, то delegat?? подстроится так, чтобы у нас норм все отображалось и в таком случае элеемнты бюудут 200 на 200, просто не 3 в ряд, а один в ряд
        case .professions:
            let itemsPerRow: CGFloat = Constant.itemPerRow
            let insets = Constant.insetForSection
            let spacing = Constant.minimumInteritemSpacingForSection
            let availableWidth = collectionView.bounds.width - insets.left - insets.right - spacing * (itemsPerRow - 1)
            let itemWidth = floor(availableWidth / itemsPerRow)
            return CGSize(width: itemWidth, height: itemWidth)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int ) -> UIEdgeInsets {
        Constant.insetForSection
    }
}

