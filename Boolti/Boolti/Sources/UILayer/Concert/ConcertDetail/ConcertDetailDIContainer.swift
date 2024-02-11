//
//  ConcertDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

final class ConcertDetailDIContainer {

    // MARK: Properties
    
    typealias Content = String
    typealias ConcertId = Int
    
    private let authRepository: AuthRepository
    private let concertRepository: ConcertRepository

    // MARK: Init
    
    init(authRepository: AuthRepository,
         concertRepository: ConcertRepository) {
        self.authRepository = authRepository
        self.concertRepository = concertRepository
    }
    
    // MARK: - Methods
    
    func createConcertDetailViewController(concertId: Int) -> ConcertDetailViewController {
        let viewModel = createConcertDetailViewModel(concertId: concertId)
        
        let loginViewControllerFactory: () -> LoginViewController = {
            let DIContainer = self.createLoginViewDIContainer()
            
            let viewController = DIContainer.createLoginViewController()
            return viewController
        }
        
        let concertContentExpandViewControllerFactory: (Content) -> ConcertContentExpandViewController = { content in
            let DIContainer = self.createConcertContentExpandDIContainer()

            let viewController = DIContainer.createConcertContentExpandViewController(content: content)
            return viewController
        }
        
        let ticketSelectionViewControllerFactory: (ConcertId) -> TicketSelectionViewController = { concertId in
            let DIContainer = self.createTicketSelectionDIContainer()

            let viewController = DIContainer.createTicketSelectionViewController(concertId: concertId)
            return viewController
        }

        let viewController = ConcertDetailViewController(
            viewModel: viewModel, 
            loginViewControllerFactory: loginViewControllerFactory,
            concertContentExpandViewControllerFactory: concertContentExpandViewControllerFactory,
            ticketSelectionViewControllerFactory: ticketSelectionViewControllerFactory
        )

        return viewController
    }
    
    private func createLoginViewDIContainer() -> LoginViewDIContainer {
        return LoginViewDIContainer(
            authRepository: self.authRepository,
            socialLoginAPIService: OAuthRepository()
        )
    }
    
    private func createConcertContentExpandDIContainer() -> ConcertContentExpandDIContainer {
        return ConcertContentExpandDIContainer()
    }
    
    private func createTicketSelectionDIContainer() -> TicketSelectionDIContainer {
        return TicketSelectionDIContainer(concertRepository: self.concertRepository)
    }
    
    private func createConcertDetailViewModel(concertId: Int) -> ConcertDetailViewModel {
        return ConcertDetailViewModel(concertRepository: self.concertRepository,
                                      concertId: concertId)
    }

}
