//
//  LayerRemover.swift
//  IOS_Course
//
//  Created by Dmytro Kharchenko on 09.03.2024.
//

import UIKit

class LayerRemover: NSObject, CAAnimationDelegate {
    private weak var layer: CALayer?
    private weak var view: UIView?

    init(for layer: CALayer, with view: UIView) {
        self.layer = layer
        self.view = view
        super.init()
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let view = view {
            if let layer = self.layer {
                layer.removeFromSuperlayer()
               // view.isHidden = true
            }
        }
    }
}
