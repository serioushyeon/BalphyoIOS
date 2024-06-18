//
//  BaseNavigationController.swift
//  Balphyo
//
//  Created by jin on 6/12/24.
//

import UIKit

class BaseNavigationController: UINavigationController {
    static func makeNavigationController(rootViewController: UIViewController) -> BaseNavigationController {
        let navigationController = BaseNavigationController(rootViewController: rootViewController)
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }

    private var backButtonImage: UIImage? {
        if let image = UIImage(named: "BackArrow") {
            return image
        } else {
            print("Error: Back button image not found.")
            return nil
        }
    }

    private var backButtonAppearance: UIBarButtonItemAppearance {
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 0.0)
        ]
        return backButtonAppearance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarAppearance()
        navigationItem.hidesBackButton = false
    }

    func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        if let backButtonImage = backButtonImage {
            appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        }
        
        appearance.backButtonAppearance = backButtonAppearance
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        
        navigationBar.tintColor = .black
    }
}
