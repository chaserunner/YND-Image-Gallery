//
//  GalleryImageViewDelegate.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 31.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import UIKit

protocol GalleryImageViewDelegate : class {
    
    func galleryViewTapped(_ galleryView: GalleryImageView)
    func galleryViewPressed(_ galleryView: GalleryImageView)
    func galleryViewDidZoomIn(_ galleryView: GalleryImageView)
    func galleryViewDidRestoreZoom(_ galleryView: GalleryImageView)
    func galleryViewDidEnableScroll(_ galleryView: GalleryImageView)
    func galleryViewDidDisableScroll(_ galleryView: GalleryImageView)
    
}
