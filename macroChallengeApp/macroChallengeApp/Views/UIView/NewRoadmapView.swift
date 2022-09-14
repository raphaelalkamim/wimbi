//
//  NewRoadmapView.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 14/09/22.
//

import Foundation
import UIKit
import SnapKit

class NewRoadmapView: UIView {
    var designSystem: DesignSystem = DefaultDesignSystem.shared
    lazy var viewCategory = CategoryView()
    lazy var viewDestiny = DestinyView()
    lazy var arrayViews = [viewCategory, viewDestiny,viewDestiny,viewDestiny]
    
    lazy var closeButtonBar: UIBarButtonItem  = .init(barButtonSystemItem: .close, target: self, action: #selector(actionDismiss))

    // MARK: scrollView
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(4), height: self.frame.height)
        
        for index in 0..<4 {
            scrollView.addSubview(arrayViews[index])
            arrayViews[index].frame = CGRect(x: self.frame.width * CGFloat(index), y: 0, width: self.frame.width, height: self.frame.height)
        }
        scrollView.delegate = self
    
        return scrollView
    }()
    
    // MARK: pageControl
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = designSystem.palette.accent
        pageControl.pageIndicatorTintColor = designSystem.palette.accent.withAlphaComponent(0.3)
        pageControl.isEnabled = false
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .valueChanged)
        return pageControl
    }()
    
    // MARK: butão
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Próximo", for: .normal)
        button.backgroundColor = designSystem.palette.backgroundPrimary
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(designSystem.palette.accent, for: .normal)
        button.addTarget(self, action: #selector(addPageContol), for: .touchUpInside)
        
        return button
        
    }()
    
    lazy var previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Anterior", for: .normal)
        button.backgroundColor = designSystem.palette.backgroundPrimary
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(designSystem.palette.accent, for: .normal)
        button.addTarget(self, action: #selector(subPageContol), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OK", for: .normal)
        button.backgroundColor = designSystem.palette.backgroundPrimary
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(designSystem.palette.accent, for: .normal)
        
    
        button.addTarget(self, action: #selector(actionDismiss), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(closeButton)
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        self.addSubview(previousButton)
        self.addSubview(nextButton)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Constraints
    func setupConstraints() {
        
        // pagecontrol
        pageControl.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(designSystem.spacing.xLargePositive)
        }
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        let pageControlConstraints:[NSLayoutConstraint] = [
            pageControl.heightAnchor.constraint(equalToConstant: 50),
            pageControl.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 30),
            pageControl.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -30),
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40)
        ]
        NSLayoutConstraint.activate(pageControlConstraints)
        
        // scrollview
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let scrollViewConstraints:[NSLayoutConstraint] = [
            scrollView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height/6),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: self.frame.height/3)
        ]
        NSLayoutConstraint.activate(scrollViewConstraints)
        
        // botoes
        nextButton.translatesAutoresizingMaskIntoConstraints=false
        let nextButtonConstraints:[NSLayoutConstraint] = [
            nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            nextButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant:-30)
        ]
        NSLayoutConstraint.activate(nextButtonConstraints)
        
        previousButton.translatesAutoresizingMaskIntoConstraints=false
        let previousButtonConstraints:[NSLayoutConstraint] = [
            previousButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            previousButton.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 30)
        ]
        NSLayoutConstraint.activate(previousButtonConstraints)
        
        closeButton.translatesAutoresizingMaskIntoConstraints=false
        let closeButton:[NSLayoutConstraint] = [
            closeButton.bottomAnchor.constraint(equalTo: self.topAnchor, constant: +50),
            closeButton.leftAnchor.constraint(equalTo: self.rightAnchor,constant: -50)
        ]
        NSLayoutConstraint.activate(closeButton)
    }

    // MARK: ação de mudar de pagina na pageControl
    @objc
    func pageControlTapHandler(sender: UIPageControl) {
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage )
        scrollView.scrollRectToVisible(frame, animated: true)
        
    }
    
    @objc
    func addPageContol() {
        if (scrollView.contentOffset.x+self.frame.width < self.frame.width*CGFloat(arrayViews.count)) {
            
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x+self.frame.width, y: 0), animated: false)
            
            if (scrollView.contentOffset.x+self.frame.width == self.frame.width*CGFloat(arrayViews.count)) {
                nextButton.setTitle("OK", for: .normal)
            }
            
        } else {
            //dismiss
            
        }
        
    }
    
    @objc
    func subPageContol() {
        nextButton.setTitle("Próximo", for: .normal)
        if (scrollView.contentOffset.x-self.frame.width>=0) {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x-self.frame.width, y: 0), animated: false)
        }
        
    }
    
    @objc
    func actionDismiss() {
        //dismiss
    }
    
    @objc
    func actionNavigateViewController() {
        //dismiss
    }
    
    func setAccessibility() {
        closeButtonBar.isAccessibilityElement = true
        closeButtonBar.accessibilityLabel = "Fechar apresentação"
        closeButtonBar.accessibilityHint = "Clique para fechar a página de apresentação"
        
        nextButton.isAccessibilityElement = true
        nextButton.accessibilityHint = "Clique para passar para a próxima página"
        previousButton.isAccessibilityElement = true
        previousButton.accessibilityHint = "Clique para voltar uma página"
        pageControl.isAccessibilityElement = true
        pageControl.accessibilityLabel = "Controle de página"
    }
}

// MARK: Delegate
extension NewRoadmapView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / self.frame.width)
        
        if pageIndex != 0 {
            previousButton.isHidden = false
        }
        pageControl.currentPage = Int(pageIndex)
    }
}
