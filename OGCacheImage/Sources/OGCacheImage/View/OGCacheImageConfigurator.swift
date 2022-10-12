//
//  File.swift
//  
//
//  Created by Мурат Камалов on 10/12/22.
//
import Combine
import Foundation

public class OGCacheImageConfigurator {
    public init() { }

    public func build(setUrl: CurrentValueSubject<URL, Never>,
                      imageService: OGImageService? = nil,
                      imageCacheService: OGImageCashService? = nil) -> OGCacheImage {
        let cacheService = imageCacheService ?? DefaultCashService()
        let imageService = imageService ?? DefaultImageService(cashService: cacheService)
        let viewModel = OGCacheImageViewModel(setUrl: setUrl,
                                              imageService: imageService)

        return OGCacheImage(viewModel: viewModel)
    }
}
