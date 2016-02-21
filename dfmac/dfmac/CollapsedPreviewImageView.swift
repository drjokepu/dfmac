//
//  CollapsedPreviewImageView.swift
//  DF Mac
//
//  Created by Tamas Czinege on 21/02/2016.
//  Copyright © 2016 Tamas Czinege. All rights reserved.
//

import Cocoa

final class CollapsedPreviewImageView: NSImageView {
    private var widthConstraint: NSLayoutConstraint?
    private var ratioConstraint: NSLayoutConstraint?
    private var bottomSpaceConstraint: NSLayoutConstraint?
    
    override var hidden: Bool {
        get {
            return super.hidden
        }
        set(value) {
            super.hidden = value
            
            findConstraints()
            
            widthConstraint?.active = !hidden
            ratioConstraint?.active = !hidden
            bottomSpaceConstraint?.active = !hidden
        }
    }
    
    private func findConstraints() {
        if widthConstraint != nil && ratioConstraint != nil && bottomSpaceConstraint != nil {
            return
        }
        
        guard let wc = findConstraintWithName("previewWidth") else {
            Swift.print("cannot find previewWidth constraint")
            return
        }
        
        guard let rc = findConstraintWithName("previewRatio") else {
            Swift.print("cannot find previewRatio constraint")
            return
        }
        
        guard let bsc = findConstraintWithName("previewBottomSpace") else {
            Swift.print("cannot find previewBottomSpace constraint")
            return
        }
        
        self.widthConstraint = wc
        self.ratioConstraint = rc
        self.bottomSpaceConstraint = bsc
    }
    
    private func findConstraintWithName(name: String) -> NSLayoutConstraint? {
        return CollapsedPreviewImageView.findConstraintWithName(name, view: self)
    }
    
    private static func findConstraintWithName(name: String, view: NSView) -> NSLayoutConstraint? {
        for constraint in view.constraints {
            if let ctid = constraint.identifier {
                if ctid == name {
                    return constraint
                }
            }
        }
        
        if let sview = view.superview {
            return CollapsedPreviewImageView.findConstraintWithName(name, view: sview)
        } else {
            return nil
        }
    }
}