//
//  ConcertDetailDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

final class ConcertDetailDIContainer {

    // MARK: Properties
    
    typealias Posters = [ConcertDetailEntity.Poster]
    typealias Content = String
    typealias ConcertId = Int
    typealias PhoneNumber = String
    
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
        
        let posterExpandViewControllerFactory: (Posters) -> PosterExpandViewController = { posters in
            let DIContainer = self.createPosterExpandDIContainer()

            let viewController = DIContainer.createPosterExpandViewController(posters: posters)
            return viewController
        }
        
        let concertContentExpandViewControllerFactory: (Content) -> ConcertContentExpandViewController = { content in
            let DIContainer = self.createConcertContentExpandDIContainer()

            let viewController = DIContainer.createConcertContentExpandViewController(content: content)
            return viewController
        }
        
        let reportViewControllerFactory: () -> ReportViewController = {
            let DIContainer = self.createReportDIContainer()

            let viewController = DIContainer.createReportViewController()
            return viewController
        }
        
        let ticketSelectionViewControllerFactory: (ConcertId) -> TicketSelectionViewController = { concertId in
            let DIContainer = self.createTicketSelectionDIContainer()

            let viewController = DIContainer.createTicketSelectionViewController(concertId: concertId)
            return viewController
        }
        
        let contactViewControllerFactory: (ContactType, PhoneNumber) -> ContactViewController = { (contactType, phoneNumber) in
            let DIContainer = self.createContactDIContainer()
            
            let viewController = DIContainer.createContactViewController(contactType: contactType, phoneNumber: phoneNumber)
            return viewController
        }

        let viewController = ConcertDetailViewController(
            viewModel: viewModel, 
            loginViewControllerFactory: loginViewControllerFactory,
            posterExpandViewControllerFactory: posterExpandViewControllerFactory,
            concertContentExpandViewControllerFactory: concertContentExpandViewControllerFactory,
            reportViewControllerFactory: reportViewControllerFactory,
            ticketSelectionViewControllerFactory: ticketSelectionViewControllerFactory,
            contactViewControllerFactory: contactViewControllerFactory
        )

        return viewController
    }
    
    private func createLoginViewDIContainer() -> LoginViewDIContainer {
        return LoginViewDIContainer(
            authRepository: self.authRepository,
            oauthRepository: OAuthRepository(),
            pushNotificationRepository: PushNotificationRepository(networkService: self.authRepository.networkService)
        )
    }
    
    private func createPosterExpandDIContainer() -> PosterExpandDIContainer {
        return PosterExpandDIContainer()
    }
    
    private func createConcertContentExpandDIContainer() -> ConcertContentExpandDIContainer {
        return ConcertContentExpandDIContainer()
    }
    
    private func createReportDIContainer() -> ReportDIContainer {
        return ReportDIContainer()
    }
    
    private func createTicketSelectionDIContainer() -> TicketSelectionDIContainer {
        return TicketSelectionDIContainer(concertRepository: self.concertRepository)
    }
    
    private func createContactDIContainer() -> ContactDIContainer {
        return ContactDIContainer()
    }
    
    private func createConcertDetailViewModel(concertId: Int) -> ConcertDetailViewModel {
        return ConcertDetailViewModel(concertRepository: self.concertRepository,
                                      concertId: concertId)
    }

}
