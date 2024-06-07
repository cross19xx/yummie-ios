//
//  ViewController.swift
//  Yummie
//
//  Created by Kenneth Kwakye-Gyamfi on 06/06/2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // TODO: Replace with the onboarding slide model
    private let onboardingSlides: [OnboardingSlide] = [
        OnboardingSlide(
            title: "Welcome to Yummie!",
            description: "Discover a world of delicious possibilities with Yummie. From local favorites to exotic dishes, we bring the best food right to your doorstep. Let's get started!",
            image: UIImage(named: "slide1")!),
        
        OnboardingSlide(
            title: "Getting Started with Yummie",
            description: "Setting up your Yummie account is easy. Just follow these simple steps to create your profile, set your delivery preferences, and start exploring our extensive menu.",
            image: UIImage(named: "slide2")!),
        
        OnboardingSlide(
            title: "Browse Your Favorite Restaurants",
            description: "With Yummie, you have access to a diverse range of restaurants. Browse through different cuisines, read reviews, and find the perfect meal for any occasion.",
            image: UIImage(named: "slide3")!),
    ]
    
    private lazy var nextButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(named: "brand")
        config.baseForegroundColor = .white
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.configuration = config
        
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPageIndicatorTintColor = UIColor(named: "brand")
        control.pageIndicatorTintColor = .systemGray5
        control.isUserInteractionEnabled = false
        
        return control
    }()
    
    private lazy var rootCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    var currentPage = 0 {
        didSet {
            let message = currentPage == onboardingSlides.count - 1 ? "Get Started" : "Next"
            
            // This adds the cross dissolve animation during text change
            UIView.transition(
                with: nextButton,
                duration: 0.15,
                options: .transitionCrossDissolve,
                animations: {
                    self.nextButton.setTitle(message, for: .normal)
                },
                completion: nil)
            
            pageControl.currentPage = currentPage
        }
    }
    
    @objc func nextButtonClicked() {
        if currentPage == onboardingSlides.count - 1 {
            let homeViewController = HomeViewController()
            navigationController?.setViewControllers([homeViewController], animated: true)
        } else {
            currentPage += 1

            let indexPath = IndexPath(item: currentPage, section: 0)
            rootCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.configure()
    }
    
    private func configure() {
        let screenBounds = UIScreen.main.bounds
        
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: screenBounds.width / 2),
            nextButton.heightAnchor.constraint(equalToConstant: 52.0),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60.0),
        ])
        
        view.addSubview(pageControl)
        pageControl.numberOfPages = onboardingSlides.count
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16.0),
        ])
        
        view.addSubview(rootCollectionView)
        rootCollectionView.dataSource = self
        rootCollectionView.delegate = self
        rootCollectionView.register(
            OnboardingCollectionViewCell.self,
            forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifer
        )
        NSLayoutConstraint.activate([
            rootCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootCollectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -16.0),
        ])
    }
}

extension OnboardingViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingSlides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCollectionViewCell.identifer,
            for: indexPath
        ) as! OnboardingCollectionViewCell
        
        let slide = onboardingSlides[indexPath.row]
        cell.configure(with: slide)
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            // Set the size for each item to be the full width of the content
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
    
}
