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
    case selectedTicket
}

class BooltiBottomSheetViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let headerHeight: CGFloat = 80
    
    // MARK: UI Component
    
    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.textColor = .grey30
        label.font = .subhead2
        return label
    }()
    
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

// MARK: - Methods

extension BooltiBottomSheetViewController {
    
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
}

// MARK: - UI

extension BooltiBottomSheetViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey85
        self.navigationController?.navigationBar.isHidden = true
        self.sheetPresentationController?.detents = [.custom { _ in return 0}]

        self.view.addSubviews([titleView, contentView])
        self.titleView.addSubview(titleLabel)
    }
    
    private func configureConstraints() {
        self.titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.titleView.snp.left).offset(24)
            make.bottom.equalTo(self.titleView.snp.bottom).offset(-12)
        }
        
        self.contentView.snp.makeConstraints { make in
            make.top.equalTo(self.titleView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func configureDefaultBottomSheet() {
        if let sheet = sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16.0
        }
    }
    
    func setDetent(contentHeight: CGFloat, contentType: BottomSheetContentType) {
        if let sheet = sheetPresentationController {
            sheet.animateChanges {
                sheet.detents = [
                    .custom { _ in
                        switch contentType {
                        case .ticketTypeList:
                            return min(self.headerHeight + contentHeight + 20, self.headerHeight + 484)
                        case .selectedTicket:
                            return min(self.headerHeight + contentHeight, self.headerHeight + 484)
                        }
                    }
                ]
            }
        }
    }
}
