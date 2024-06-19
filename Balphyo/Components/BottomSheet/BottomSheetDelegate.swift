//
//  BottomSheetDelegate.swift
//  Balphyo
//
//  Created by jin on 6/19/24.
//

import Foundation
import UIKit

final class BottomSheetDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}

