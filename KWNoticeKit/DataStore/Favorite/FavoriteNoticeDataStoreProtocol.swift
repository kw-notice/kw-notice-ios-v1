//
//  FavoriteNoticeDataStoreProtocol.swift
//  KWNoticeKit
//
//  Created by 김세영 on 2022/07/09.
//

import Foundation

public protocol FavoriteNoticeDataStoreProtocol {
    func fetch() -> [Favorite]?
    func save(kwHomeNotice: KWHomeNotice) -> Bool
    func save(swCentralNotice: SWCentralNotice) -> Bool
    func delete(_ id: Int, type: String) -> Bool
}
