//
//  LinkPickerDelegate.swift
//  Colorizer
//
//  Created by Artyom Gurbovich on 13.11.21.
//

import Foundation

protocol LinkPickerDelegate: AnyObject {
    func linkPicker(_ controller: LinkPickerViewController, didPickLink link: String)
}
