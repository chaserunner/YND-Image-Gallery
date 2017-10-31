//
//  GalleryViewController.swift
//  Image Gallery
//
//  Created by Illia Lukisha on 31.10.2017.
//  Copyright © 2017 Illia Lukisha. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    //MARK:- Properties
    
    fileprivate var photos: [PhotoWithAuthorCount] = []
    fileprivate var photoViews: [GalleryImageView] = []
    fileprivate var datasource: ListTableViewDatasource!
    
    fileprivate var isShowingActionControls: Bool {
        get {
            return !closeButton.isHidden
        }
    }
    
    fileprivate var activityController: UIActivityViewController!
    
    internal var displayedView: GalleryImageView {
        get {
            return photoViews[currentIndex]
        }
    }
    
    fileprivate var currentIndex: Int = 0
    fileprivate var pagingScrollView: UIScrollView!
    fileprivate var closeButton: UIButton!
    
    fileprivate var captionView: CaptionView!
    
    var displayedImageView: UIImageView {
        get {
            return displayedView.imageView
        }
    }
    
    // MARK: - Initializers
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    public convenience init(datasource: ListTableViewDatasource, index: Int = 0) {
        self.init(nibName: nil, bundle: nil)
        self.datasource = datasource
        self.photos = datasource.getPhotos
        self.currentIndex = index
    }
    
    
    // MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        pagingScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToIndex(currentIndex, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCaptionText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionView.layoutIfNeeded()
        captionView.setNeedsLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pagingScrollView.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        clearImagesFarFromIndex(currentIndex)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Private functions
    
    fileprivate func setupView() {
        view.backgroundColor = .black
        setupScrollView()
        setupPictures()
        setupCloseButton()
        setupCaptionView()
        loadImagesNextToIndex(currentIndex)
    }
    
    fileprivate func setupScrollView() {
        let avaiableSize = getInitialAvaiableSize()
        let scrollFrame = getScrollViewFrame(avaiableSize)
        let contentSize = getScrollViewContentSize(scrollFrame)
        pagingScrollView = UIScrollView(frame: scrollFrame)
        pagingScrollView.isPagingEnabled = true
        pagingScrollView.showsHorizontalScrollIndicator = true
        pagingScrollView.backgroundColor = UIColor.clear
        pagingScrollView.contentSize = contentSize
        pagingScrollView.indicatorStyle = .white
        view.addSubview(pagingScrollView)
    }
    
    fileprivate func setupPictures() {
        let avaiableSize = getInitialAvaiableSize()
        let scrollFrame = getScrollViewFrame(avaiableSize)
        for i in 0 ..< photos.count {
            let photo = photos[i]
            let photoFrame = getPhotoFrame(scrollFrame, pictureIndex: i)
            let photoView = GalleryImageView(photo: photo.photo, frame: photoFrame)
            photoView.delegate = self
            pagingScrollView.addSubview(photoView)
            photoViews.append(photoView)
        }
    }
    
    fileprivate func setupCloseButton() {
        if self.closeButton != nil {
            self.closeButton.removeFromSuperview()
        }
        let avaiableSize = getInitialAvaiableSize()
        let closeButtonFrame = getCloseButtonFrame(avaiableSize)
        let closeButton = UIButton(frame: closeButtonFrame)
        closeButton.setTitle("+", for: UIControlState())
        closeButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 30)
        closeButton.setTitleColor(.white, for: UIControlState())
        closeButton.transform = CGAffineTransform(rotationAngle: .pi / 4)
        closeButton.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        var shouldBeHidden = false
        if self.closeButton != nil {
            shouldBeHidden = closeButton.isHidden
        }
        closeButton.isHidden = shouldBeHidden
        self.closeButton = closeButton
        view.addSubview(self.closeButton)
    }
    
    fileprivate func setupCaptionView() {
        let avaiableSize = getInitialAvaiableSize()
        let captionViewFrame = getCaptionViewFrame(avaiableSize)
        
        let captionView = CaptionView(frame: captionViewFrame)
        self.captionView = captionView
        
        view.addSubview(self.captionView)
    }
    
    fileprivate func updateView(_ avaiableSize: CGSize) {
        pagingScrollView.frame = getScrollViewFrame(avaiableSize)
        pagingScrollView.contentSize = getScrollViewContentSize(pagingScrollView.frame)
        
        for i in 0 ..< photoViews.count {
            let innerView = photoViews[i]
            innerView.frame = getPhotoFrame(pagingScrollView.frame, pictureIndex: i)
        }
        setupCloseButton()
        updateContentOffset()
        updateCaptionText()
    }
    
    fileprivate func loadImagesNextToIndex(_ index: Int) {
        photoViews[index].loadImage()
        
        let imagesToLoad = 1
        
        for i in 1 ... imagesToLoad {
            let previousIndex = index - i
            let nextIndex = index + i
            
            if previousIndex >= 0 {
                photoViews[previousIndex].loadImage()
            }
            
            if nextIndex < photoViews.count {
                photoViews[nextIndex].loadImage()
            }
        }
    }
    
    fileprivate func clearImagesFarFromIndex(_ index: Int) {
        let imagesToLoad = 1
        let firstIndex = max(index - imagesToLoad, 0)
        let lastIndex = min(index + imagesToLoad, photoViews.count - 1)
        
        var imagesCleared = 0
        
        for i in 0 ..< photoViews.count {
            if i < firstIndex || i > lastIndex {
                photoViews[i].clearImage()
                imagesCleared += 1
            }
        }
        
        print("\(imagesCleared) images cleared.")
    }
    
    fileprivate func updateContentOffset() {
        pagingScrollView.setContentOffset(CGPoint(x: pagingScrollView.frame.size.width * CGFloat(currentIndex), y: 0), animated: false)
    }
    
    fileprivate func getInitialAvaiableSize() -> CGSize {
        return view.bounds.size
    }
    
    fileprivate func getScrollViewFrame(_ avaiableSize: CGSize) -> CGRect {
        let x: CGFloat = -10
        let y: CGFloat = 0.0
        let width: CGFloat = avaiableSize.width + 10
        let height: CGFloat = avaiableSize.height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    fileprivate func getScrollViewContentSize(_ scrollFrame: CGRect) -> CGSize {
        let width = scrollFrame.size.width * CGFloat(photos.count)
        let height = scrollFrame.size.height
        
        return CGSize(width: width, height: height)
    }
    
    fileprivate func getPhotoFrame(_ scrollFrame: CGRect, pictureIndex: Int) -> CGRect {
        let x: CGFloat = ((scrollFrame.size.width) * CGFloat(pictureIndex)) + 10
        let y: CGFloat = 0.0
        let width: CGFloat = scrollFrame.size.width - (1 * 10)
        let height: CGFloat = scrollFrame.size.height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    fileprivate func toggleControlsVisibility() {
        if isShowingActionControls {
            hideControls()
        } else {
            showControls()
        }
    }
    
    fileprivate func showControls() {
        closeButton.isHidden = false
        captionView.isHidden = captionView.titleLabel.text == nil && captionView.captionLabel.text == nil
        
        UIView.animate(withDuration: 0.2, delay: 0.0,
                       options: UIViewAnimationOptions(),
                       animations: { [weak self] in
                        self?.closeButton.alpha = 1.0
                        self?.captionView.alpha = 1.0
            }, completion: nil)
    }
    
    fileprivate func hideControls() {
        UIView.animate(withDuration: 0.2, delay: 0.0,
                       options: UIViewAnimationOptions(),
                       animations: { [weak self] in
                        self?.closeButton.alpha = 0.0
                        self?.captionView.alpha = 0.0
            },
                       completion: { [weak self] _ in
                        self?.closeButton.isHidden = true
                        self?.captionView.isHidden = true
        })
    }
    
    fileprivate func getCaptionViewFrame(_ availableSize: CGSize) -> CGRect {
        return CGRect(x: 0.0, y: availableSize.height - 70, width: availableSize.width, height: 70)
    }
    
    fileprivate func getCloseButtonFrame(_ avaiableSize: CGSize) -> CGRect {
        return CGRect(x: 0, y: 0, width: 50, height: 50)
    }
    
    fileprivate func updateCaptionText () {
        let photo = photos[currentIndex]
        captionView.titleLabel.text = photo.photo.user.name + " " + String(photo.count)
        captionView.captionLabel.text = "\(photo.photo.width)x\(photo.photo.height)"
        captionView.adjustView()
    }
    
    // MARK: - Internal functions
    @objc internal func closeButtonTouched(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Public functions
    
    func scrollToIndex(_ index: Int, animated: Bool = true) {
        currentIndex = index
        loadImagesNextToIndex(currentIndex)
        pagingScrollView.setContentOffset(CGPoint(x: pagingScrollView.frame.size.width * CGFloat(index), y: 0), animated: animated)
    }
    
}

//MARK:- UIScrollViewDelegate

extension GalleryViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in 0 ..< photoViews.count {
            photoViews[i].scrollView.contentOffset = CGPoint(x: 0 , y: 0)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        currentIndex = page
        loadImagesNextToIndex(currentIndex)
        updateCaptionText()
    }
    
}

//MARK:- GalleryImageViewDelegate

extension GalleryViewController: GalleryImageViewDelegate {
    
    func galleryViewTapped(_ scrollview: GalleryImageView) {
        let scrollView = photoViews[currentIndex].scrollView
        if scrollView?.zoomScale == scrollView?.minimumZoomScale {
            toggleControlsVisibility()
        }
    }
    
    func galleryViewPressed(_ scrollview: GalleryImageView) {
        showControls()
    }
    
    func galleryViewDidRestoreZoom(_ galleryView: GalleryImageView) {
        showControls()
    }
    
    func galleryViewDidZoomIn(_ galleryView: GalleryImageView) {
        hideControls()
    }
    
    func galleryViewDidEnableScroll(_ galleryView: GalleryImageView) {
        pagingScrollView.isScrollEnabled = false
    }
    
    func galleryViewDidDisableScroll(_ galleryView: GalleryImageView) {
        pagingScrollView.isScrollEnabled = true
    }
    
}

