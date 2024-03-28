//
//  BooltiBottomSheet.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/26/24.
//

import UIKit

import RxSwift
import SnapKit

enum BottomSheetContentType {
    case ticketTypeList
    case selectedSalesTicket
    case selectedInvitationTicket
}

class BooltiBottomSheetViewController: BooltiViewController {
    
    // MARK: UI Component
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureUI()
        self.configureConstraints()
        self.configureDefaultBottomSheet()
    }
}

// MARK: - UI

extension BooltiBottomSheetViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey85
        self.navigationController?.navigationBar.isHidden = true
        self.sheetPresentationController?.detents = [.custom { _ in return 0}]

        self.view.addSubviews([self.contentView])
    }
    
    private func configureConstraints() {
        self.contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func configureDefaultBottomSheet() {
        if let sheet = sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
    }
    
    func setDetent(contentHeight: CGFloat) {
        if let sheet = sheetPresentationController {
            sheet.animateChanges {
                sheet.detents = [
                    .custom { _ in
                        return min(contentHeight, 484)
                    }
                ]
            }
        }
    }
}
