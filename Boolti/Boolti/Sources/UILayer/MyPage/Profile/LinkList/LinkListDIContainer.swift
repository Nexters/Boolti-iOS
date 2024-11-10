//
//  LinkListDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/10/24.
//

import UIKit

final class LinkListDIContainer {

    func createLinkListViewController(linkList: [LinkEntity]) -> LinkListViewController {
        let viewModel = LinkListViewModel(linkList: linkList)
        let viewController = LinkListViewController(viewModel: viewModel)

        return viewController
    }

}
