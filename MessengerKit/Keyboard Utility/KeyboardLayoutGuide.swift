//
//  KeyboardLayoutGuide.swift
//  KeyboardUtility
//
//  Created by Jonny on 9/10/17.
//  Copyright © 2017 Jonny. All rights reserved.
//
//

import UIKit

public class KeyboardLayoutGuide : UILayoutGuide {
    
    private var observer: KeyboardFrameObserver?
    
    public override var owningView: UIView? {
        didSet {
            guard let view = owningView else {
                observer = nil
                return
            }
            
            let topConstraint = view.bottomAnchor.constraint(equalTo: topAnchor)
            topConstraint.constant = 0
            topConstraint.priority = .defaultHigh
            
            let heightConstraint = heightAnchor.constraint(equalToConstant: 0)
            heightConstraint.constant = 291
            
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: view.leadingAnchor),
                trailingAnchor.constraint(equalTo: view.trailingAnchor),
                topConstraint,
                heightConstraint,
            ])
            
            // layoutGuide.layoutFrame.origin.y <= view.bounds.height
            if #available(iOS 11.0, *) {
                topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            } else {
                topAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor).isActive = true
            }
            
            observer = KeyboardFrameObserver(view: view) { [weak view] keyboardFrame, animated in
                guard let view = view else { return }
                print("BEFORE")
                print(topConstraint.constant)
                print(heightConstraint.constant)
                let topSpace = view.bounds.height - keyboardFrame.origin.y
                if topSpace <= 400 {
                    topConstraint.constant = view.bounds.height - keyboardFrame.origin.y
                }
                heightConstraint.constant = keyboardFrame.height
                print("AFTER")
                print(topConstraint.constant)
                print(heightConstraint.constant)
                if animated {
                    view.layoutIfNeeded()
                }
            }
        }
    }
}
