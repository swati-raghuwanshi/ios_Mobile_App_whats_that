//
//  WikipediaResult.swift
//  WatsDat
//
//  Created by Swati Raghuwanshi on 12/9/17.
//  Copyright © 2017 Swati Raghuwanshi. All rights reserved.
//

import Foundation

struct Wiki: Decodable {
    let title: String
    let extract: String
    let pageid: Int
}
