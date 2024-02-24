//
//  PosterExpandViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/24/24.
//

import UIKit

import RxSwift

final class PosterExpandViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let viewModel: PosterExpandViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.closeButton, for: .normal)
        return button
    }()
    
    private lazy var posterScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    private let pageControl = UIPageControl()
    
    // MARK: Init
    
    init(viewModel: PosterExpandViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.bindUIComponents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.configureScrollView()
    }
}

// MARK: - Methods

extension PosterExpandViewController {
    
    private func bindUIComponents() {
        self.closeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureScrollView() {
        let scrollViewWidth: CGFloat = self.view.frame.width
        let scrollViewHeight: CGFloat = self.pageControl.frame.minY - self.closeButton.frame.maxY - 30
        
        for index in 0..<self.viewModel.posters.count{
            let backgroundView = UIView()

            let imageView = UIImageView()
            imageView.setImage(with: self.viewModel.posters[index].path)
            imageView.contentMode = .scaleAspectFit

            let positionX = scrollViewWidth * CGFloat(index)
            backgroundView.frame = CGRect(x: positionX, y: 0, width: scrollViewWidth, height: scrollViewHeight)
            
            backgroundView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.edges.equalTo(backgroundView)
            }
            
            self.posterScrollView.addSubview(backgroundView)
        }
        
        self.posterScrollView.contentSize = CGSize(
            width: scrollViewWidth * CGFloat(self.viewModel.posters.count),
            height: scrollViewHeight
        )
        self.pageControl.numberOfPages = self.viewModel.posters.count
    }
}

// MARK: - UIScrollViewDelegate

extension PosterExpandViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(round(self.posterScrollView.contentOffset.x / self.view.frame.width))
        self.pageControl.currentPage = currentPage
    }
}

// MARK: - UI

extension PosterExpandViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.closeButton,
                               self.posterScrollView,
                               self.pageControl])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.closeButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
        
        self.posterScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(44)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(47)
        }
        
        self.pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }
}
