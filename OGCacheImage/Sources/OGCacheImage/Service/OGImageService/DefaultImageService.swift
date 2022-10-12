//
//  File.swift
//  
//
//  Created by Мурат Камалов on 10/12/22.
//

import Foundation
import Combine
import UIKit

class DefaultImageService: OGImageService {
    private var cashService: OGImageCashService

    init(cashService: OGImageCashService) {
        self.cashService = cashService
    }

    func getImage(by url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cashService[url] {
            return Just(image).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.cashService[url] = image
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

