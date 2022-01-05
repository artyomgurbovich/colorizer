//
//  AccessViewModelDelegate.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 9.11.21.
//

import Foundation

protocol AccessViewModel: AnyObject {
    
    func allowDidTapped(completion: @escaping () -> ())
    func skipDidTapped()
}
