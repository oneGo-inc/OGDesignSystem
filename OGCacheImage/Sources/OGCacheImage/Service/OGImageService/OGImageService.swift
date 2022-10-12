//
//  File.swift
//  
//
//  Created by Мурат Камалов on 10/12/22.
//

import Combine
import Foundation
import UIKit

public protocol OGImageService {
    func getImage(by url: URL) -> AnyPublisher<UIImage?, Never>
}

