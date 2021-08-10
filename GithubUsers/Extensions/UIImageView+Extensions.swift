//
//  UIImageView+Extensions.swift
//  GithubUsers
//
//  Created by Thinh Le on 10/08/2021.
//

import Foundation
import Kingfisher
import UIKit

extension UIImageView {
    func setImage(from urlString: String?, placeHolder image: UIImage? = nil) {
        guard let string = urlString, let url = URL(string: string) else {
            self.image = nil
            return
        }
        
        let lastPath = url.lastPathComponent
        let cacheName = "ImageCache"
        let imageCache = ImageCache.init(name: cacheName)
        let resource = ImageResource(downloadURL: url, cacheKey: lastPath)
        let option: KingfisherOptionsInfo = [
            .targetCache(imageCache),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage,
            .keepCurrentImageWhileLoading
        ]
        
        kf.setImage(
            with: resource,
            placeholder: image,
            options: option)
    }
}
