//
//  GoogleVisionResult.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/9/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import Foundation

struct Label: Decodable {
    let description: String
    let score: Float
}
