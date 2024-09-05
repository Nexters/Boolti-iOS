//
//  EditProfileImageView.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/4/24.
//

import UIKit

final class EditProfileImageView: UIView {
    
    // MARK: UI Components
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = .grey80
        imageView.layer.borderColor = UIColor.grey80.cgColor
        imageView.layer.borderWidth = 1
        imageView.image = .defaultProfile
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .camera
        return imageView
    }()
    
    // MARK: Initailizer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Methods

extension EditProfileImageView {
    
    func setImage(imageURL: String) {
        self.profileImageView.setImage(with: imageURL)
    }
    
}

// MARK: - UI

extension EditProfileImageView {
    
    private func configureUI() {
        self.backgroundColor = .grey95
        self.addSubviews([self.profileImageView,
                          self.cameraImageView])

        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        
        self.profileImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }

        self.cameraImageView.snp.makeConstraints { make in
            make.bottom.equalTo(self.profileImageView)
            make.trailing.equalTo(self.profileImageView).offset(8)
            make.size.equalTo(40)
        }
    }
}
