//
//  File.swift
//  
//
//  Created by Мурат Камалов on 10/12/22.
//

import Combine
import UIKit

public class OGCacheImageViewModel {
    private var imageService: OGImageService

    public var onSetImage = PassthroughSubject<UIImage?, Never>()
    public var setUrl: CurrentValueSubject<URL?, Never>

    private var cancellableSet = Set<AnyCancellable>()

    public init(setUrl: CurrentValueSubject<URL?, Never>,
                imageService: OGImageService) {
        self.setUrl = setUrl
        self.imageService = imageService
    }
}

private extension OGCacheImageViewModel {
    func bind() {
        setUrl
            .sink { [weak self] url in
                guard let url else { return }
                self?.getImage(url: url)
            }
            .store(in: &cancellableSet)
    }

    func getImage(url: URL) {
        imageService.getImage(by: url)
            .sink { [weak self] image in
                self?.onSetImage.send(image)
            }
            .store(in: &cancellableSet)
    }
}
