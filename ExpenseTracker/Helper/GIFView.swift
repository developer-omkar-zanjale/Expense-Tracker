//
//  GIFView.swift
//  ExpenseTracker
//
//  Created by Omkar Zanjale on 30/12/22.
//

import Foundation
import SwiftUI
import FLAnimatedImage

struct GIFView: UIViewRepresentable {
    
    let animatedView = FLAnimatedImageView()
    var fileName: String
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        guard let path = Bundle.main.path(forResource: fileName, ofType: "gif") else {return UIView()}
        let url = URL(fileURLWithPath: path)
        do {
            let gifData = try Data(contentsOf: url)
            let gif = FLAnimatedImage(animatedGIFData: gifData)
            animatedView.animatedImage = gif
            animatedView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(animatedView)
            
            NSLayoutConstraint.activate([
                animatedView.heightAnchor.constraint(equalTo: view.heightAnchor),
                animatedView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
            
            return view
        } catch {
            return UIView()
        }
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
