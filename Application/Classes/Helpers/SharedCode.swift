//
//  SharedCode.swift
//  TriMeter
//
//  Created by Bram Nouwen on 22/12/17.
//  Copyright © 2017 Bram Nouwen. All rights reserved.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    return paths[0]
}
