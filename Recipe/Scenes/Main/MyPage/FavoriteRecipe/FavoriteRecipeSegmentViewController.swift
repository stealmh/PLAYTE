//
//  FavoriteRecipeSegmentViewController.swift
//  Recipe
//
//  Created by 김민호 on 2023/10/26.
//

import UIKit

class FavoriteRecipeSegmentViewController: BaseViewController {
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UnderlineSegmentedControl(items: ["글 레시피 0", "숏폼 레시피 0"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let vc1: FavoriteRecipeViewController!
    private var vc2: FavoriteShortFormViewController!
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    var dataViewControllers: [UIViewController] {
        [self.vc1, self.vc2]
    }
    var currentPage: Int = 0 {
        didSet {
            // from segmentedControl -> pageViewController 업데이트
            print(oldValue, self.currentPage)
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [dataViewControllers[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    init(data1: [RecipeInfo1]) {
        vc1 = FavoriteRecipeViewController(data1: data1)
        vc2 = FavoriteShortFormViewController()

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let v = UILabel()
        v.text = "레시피"
        navigationItem.titleView = v
        
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.pageViewController.view)
        
        NSLayoutConstraint.activate([
            self.segmentedControl.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.segmentedControl.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.segmentedControl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.segmentedControl.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            self.pageViewController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4),
            self.pageViewController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4),
            self.pageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -4),
            self.pageViewController.view.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 5),
        ])
        
        self.segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)], for: .normal)
        self.segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.mainColor,
                .font: UIFont.systemFont(ofSize: 13, weight: .semibold)
            ],
            for: .selected
        )
        self.segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.changeValue(control: self.segmentedControl)
        defaultNavigationBackButton(backButtonColor: .gray)
    }
    
    @objc private func changeValue(control: UISegmentedControl) {
        self.currentPage = control.selectedSegmentIndex
    }
}

extension FavoriteRecipeSegmentViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.dataViewControllers.firstIndex(of: viewController),
            index - 1 >= 0
        else { return nil }
        return self.dataViewControllers[index - 1]
    }
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let index = self.dataViewControllers.firstIndex(of: viewController),
            index + 1 < self.dataViewControllers.count
        else { return nil }
        return self.dataViewControllers[index + 1]
    }
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let viewController = pageViewController.viewControllers?[0],
            let index = self.dataViewControllers.firstIndex(of: viewController)
        else { return }
        self.currentPage = index
        self.segmentedControl.selectedSegmentIndex = index
    }
}

