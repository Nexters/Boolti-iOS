//
//  QRScannerListTableViewCell.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

import UIKit

final class QRScannerListTableViewCell: UITableViewCell {
    
    // MARK: UI Component
    
    private let cellBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey90
        return view
    }()
    
    private let concertNameLabel: BooltiUILabel = {
        let label = BooltiUILabel()
        label.font = .aggroB(16)
        label.numberOfLines = 2
        return label
    }()
    
    private let scannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .qrScanner.withRenderingMode(.alwaysTemplate)
        return imageView
    }()
    
    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.configureUI()
        self.configureConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Override
    
    override func prepareForReuse() {
        self.resetData()
    }
}

// MARK: - Methods

extension QRScannerListTableViewCell {
    
    func setData(concertName: String, isConcertEnd: Bool) {
        self.concertNameLabel.text = concertName
        
        if isConcertEnd {
            self.concertNameLabel.textColor = .grey50
            self.scannerImageView.tintColor = .grey50
        } else {
            self.concertNameLabel.textColor = .grey05
            self.scannerImageView.tintColor = .grey05
        }
    }
    
    private func resetData() {
        self.concertNameLabel.text = nil
    }
}

// MARK: - UI

extension QRScannerListTableViewCell {
    
    private func configureUI() {
        self.addSubviews([self.cellBackgroundView, self.concertNameLabel, self.scannerImageView])
        
        self.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.cellBackgroundView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
        }
        
        self.concertNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.cellBackgroundView)
            make.left.equalToSuperview().inset(20)
            make.right.equalTo(self.scannerImageView.snp.left).offset(-12)
        }
        
        self.scannerImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.cellBackgroundView)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
    }
}
