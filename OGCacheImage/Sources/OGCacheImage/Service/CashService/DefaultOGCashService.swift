//
//  File.swift
//  
//
//  Created by Мурат Камалов on 10/12/22.
//
import Foundation
import UIKit

class DefaultCashService {
    private lazy var сache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        return cache
    }()

    private lazy var decodeCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()

    private let lock = NSLock()
    private let config: Config

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
}

extension DefaultCashService: OGImageCashService {
    func image(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        // the best case scenario -> there is a decoded image
        if let decodedImage = decodeCache.object(forKey: url as AnyObject) as? UIImage {
            return decodedImage
        }
        // search for image data
        if let image = сache.object(forKey: url as AnyObject) as? UIImage {
            let decodedImage = image.decodedImage()
            decodeCache.setObject(image as AnyObject, forKey: url as AnyObject)
            return decodedImage
        }
        return nil
    }

    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }
        let decodedImage = image.decodedImage()

        lock.lock(); defer { lock.unlock() }
        сache.setObject(decodedImage, forKey: url as AnyObject)
        decodeCache.setObject(image as AnyObject, forKey: url as AnyObject)
    }

    func removeImage(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        сache.removeObject(forKey: url as AnyObject)
        decodeCache.removeObject(forKey: url as AnyObject)
    }

    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
}
