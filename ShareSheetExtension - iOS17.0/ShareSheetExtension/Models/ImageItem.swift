//
//  ImageItem.swift
//  ShareSheetExtension
//
//  Created by Lam Hoang Tung on 2/5/24.
//

import SwiftUI
import SwiftData

@Model
class ImageItem {
    @Attribute(.externalStorage)
    var data: Data
    init(data: Data) {
        self.data = data
    }
}
