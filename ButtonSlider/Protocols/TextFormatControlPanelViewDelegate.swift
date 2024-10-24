//
//  TextFormatControlPanelViewDelegate.swift
//  ButtonSlider
//
//  Created by Ranix on 2024/10/25.
//

import Foundation

protocol TextFormatControlPanelViewDelegate: NSObject {
    func onTextFormatChanged(_ textFormat: TextFormat, isUndoRedo: Bool)
}
