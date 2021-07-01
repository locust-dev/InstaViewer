//
//  IndicatorCell.swift
//  ProjectAPI
//
//  Created by Илья Тюрин on 01.07.2021.
//

import UIKit

class IndicatorCell: UICollectionViewCell {
    var indicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        contentView.addSubview(indicator)
        indicator.center = contentView.center
        indicator.startAnimating()
    }
    
}
