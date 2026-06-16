import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    // MARK: - Setup

    private func setupTabs() {
        let translatorVC = makeNav(
            root: TranslatorViewController(),
            title: "Translator",
            image: "character.bubble.fill",
            tag: 0
        )

        let flashCardsVC = makeNav(
            root: UICollectionViewController(),
            title: "Flash Cards",
            image: "square.stack.fill",
            tag: 1
        )

        let categoriesVC = makeNav(
            root: CategoriesViewController(),
            title: "Categories",
            image: "square.grid.2x2.fill",
            tag: 2
        )

        viewControllers = [translatorVC, flashCardsVC, categoriesVC]
    }

    private func makeNav(root: UIViewController, title: String, image: String, tag: Int) -> UINavigationController {
        root.title = title
        let nav = UINavigationController(rootViewController: root)
        nav.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: image), tag: tag)
        return nav
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = UIColor.darkBlue.withAlphaComponent(0.1)

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.selected.iconColor = .darkBlue
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.darkBlue,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]
        itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
        itemAppearance.normal.iconColor = UIColor.darkCyan.withAlphaComponent(0.45)
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.darkCyan.withAlphaComponent(0.45),
            .font: UIFont.systemFont(ofSize: 11)
        ]
        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)

        appearance.stackedLayoutAppearance = itemAppearance
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .darkBlue
    }
}
