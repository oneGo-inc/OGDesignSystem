//
//  File.swift
//  
//
//  Created by Мурат Камалов on 10/12/22.
//

import Foundation

extension DefaultCashService {
    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }
}
