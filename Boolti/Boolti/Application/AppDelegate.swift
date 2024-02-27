//
//  AppDelegate.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import UIKit

import UserNotifications
import RxKakaoSDKCommon
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let pushNotificationRepository = PushNotificationRepository(networkService: NetworkProvider())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RxKakaoSDK.initSDK(appKey: Environment.KAKAO_NATIVE_APP_KEY)
        FirebaseApp.configure()

        /// 앱 실행 시 알림 허용 권한 받기 및 필요한 권한 설정
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()

        /// 메시지 대리자 설정
        Messaging.messaging().delegate = self

        /// 자동 초기화 방지
        Messaging.messaging().isAutoInitEnabled = true

        return true
    }

    /// fcm에 device token 등록
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {

    /// 토큰 갱신 모니터링 & 토큰 가져오기
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        UserDefaults.deviceToken = fcmToken
        // TODO: device token 등록 서버 api 연결 or 회원가입 시 넣기
        debugPrint(fcmToken)
        self.registerSubject()
        
        // 토큰이 갱신될 경우
        self.pushNotificationRepository.registerDeviceToken()
    }

    private func registerSubject() {
        /// 주제 구독
        let defaultTopic: String

        #if DEBUG
        defaultTopic = "dev"
        #elseif RELEASE
        defaultTopic = "prod"
        #endif

        Messaging.messaging().subscribe(toTopic: defaultTopic) { error in
            if let error {
                print(error)
            } else {
                print("구독을 완료했습니다.")
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {

    /// 푸시 클릭시
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        let messageTitle = response.notification.request.content.title
        let messageBody = response.notification.request.content.body

        completionHandler()
    }

    /// Foreground에 푸시알림이 올 때 실행되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .list, .banner])
    }
}
