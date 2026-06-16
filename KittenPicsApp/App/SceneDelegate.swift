import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        setupNavigationBarAppearance()

        let tabBarController = MainTabBarController()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    // MARK: - Appearance

    // MARK: - Appearance

    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.darkBlue,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        appearance.shadowColor = UIColor.darkBlue.withAlphaComponent(0.1)

        let edgeAppearance = UINavigationBarAppearance()
        edgeAppearance.configureWithTransparentBackground()
        edgeAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.darkBlue,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = edgeAppearance
        UINavigationBar.appearance().tintColor = .darkBlue
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

