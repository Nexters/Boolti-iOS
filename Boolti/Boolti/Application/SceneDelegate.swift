//
//  SceneDelegate.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import UIKit

import RxKakaoSDKAuth
import KakaoSDKAuth
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        if let userActivity = connectionOptions.userActivities.first {
            self.scene(scene, continue: userActivity)
        }

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .light

        let rootDIContainer = RootDIContainer()
        let rootViewController = rootDIContainer.createRootViewController()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLinks, error in

                // 현재 파라미터가 하나 뿐이므로 일단 showID만 때내기
                // 만약 다른 dynamic link가 들어오게 되면 다른 함수로 빼서 처리하기!
                guard let url = dynamicLinks?.url else { return }
                let urlString = url.absoluteString
                let components = urlString.split(separator: "/")

                guard let lastComponent = components.last else { return }
                guard let concertID = Int(lastComponent) else { return }
                UserDefaults.concertID = concertID

                // active인지 아닌 지를 확인해서 둘 메소드 다 실행되지는 않게 구현하기
                NotificationCenter.default.post(
                    name: Notification.Name.didTabBarSelectedIndexChanged,
                    object: nil,
                    userInfo: ["tabBarIndex" : HomeTab.concert.rawValue]
                )
                NotificationCenter.default.post(
                    name: Notification.Name.NavigationDestination.concertDetail,
                    object: nil
                )
            }
        }
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

