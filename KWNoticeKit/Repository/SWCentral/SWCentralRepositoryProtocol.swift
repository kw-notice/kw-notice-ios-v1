//
//  SWCentralRepositoryProtocol.swift
//  KWNoticeKit
//
//  Created by 김세영 on 2022/07/04.
//

import Foundation
import Combine

public protocol SWCentralRepositoryProtocol {
    func fetch() async throws -> [SWCentralNotice]
    func search(text: String) -> [SWCentralNotice]
}
