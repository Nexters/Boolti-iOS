//
//  SplashViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

final class SplashViewController: UIViewController {

    // 여기서 Token이 있는 지 확인해서
    // 아예 AuthenticationRepository에 Home에서 해당 Token을 넣어주는 것도 좋을 듯
    // Authentication은 프로퍼티로 토큰을 갖고!..

    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: 화면 넘어가는 거 확인용. 나중에 지워야함!
        self.view.backgroundColor = .orange
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let splashDuration: DispatchTimeInterval = .seconds(2)

        // TODO: Delegate을 활용해서 Splash View -> RootView -> TabBar로 넘어가는 로직 구현할 예정!
        DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) { [weak self] in
            // ViewModel의 메소드를 실행시킨다.

        }
    }
}
