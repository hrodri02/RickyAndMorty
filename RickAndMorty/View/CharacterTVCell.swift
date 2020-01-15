//
//  CharacterTVCell.swift
//  RickAndMorty
//
//  Created by Eri on 1/14/20.
//  Copyright © 2020 Eri. All rights reserved.
//

import UIKit

class CharacterTVCell: UITableViewCell
{
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Medium", size: 14.0)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 12.0)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupUiComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(characterImageView)
        addSubview(nameLabel)
        addSubview(dateLabel)
    }
    
    private func setupUiComponents() {
        setCharacterImageViewConstraints()
        setNameLabelConstraints()
        setDateLabelConstraints()
    }
    
    private func setCharacterImageViewConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
            characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 40.0),
            characterImageView.widthAnchor.constraint(equalToConstant: 40.0)
            ])
    }
    
    private func setNameLabelConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10.0),
            nameLabel.bottomAnchor.constraint(equalTo: characterImageView.centerYAnchor, constant: -2.5)
            ])
    }
    
    private func setDateLabelConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10.0),
            dateLabel.topAnchor.constraint(equalTo: characterImageView.centerYAnchor, constant: 2.5)
            ])
    }
}
