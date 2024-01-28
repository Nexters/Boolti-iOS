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
    case TicketTypeList
    case SelectedTicket
}

class BooltiBottomSheetViewController: UIViewController {
    
    // MARK: Properties
    
    private let headerHeight: CGFloat = 80
    
    // MARK: UI Component
    
    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grey10
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
    
    /// detent를 변경한다. (ex. 티켓을 여러장 구매할 경우 화면에 추가 등)
    func setDetent(contentHeight: CGFloat, contentType: BottomSheetContentType) {
        if let sheet = sheetPresentationController {
            sheet.animateChanges {
                sheet.detents = [
                    .custom { _ in
                        switch contentType {
                        case .TicketTypeList:
                            return min(self.headerHeight + contentHeight + 20, self.headerHeight + 484)
                        case .SelectedTicket:
                            return min(self.headerHeight + contentHeight, self.headerHeight + 484)
                        }
                    }
                ]
            }
        }
    }
}
