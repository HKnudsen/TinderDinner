//
//  DinnerInfoCell.swift
//  TinderDinner
//
//  Created by Henrik Bouwer Knudsen on 10/03/2021.
//

import UIKit

class DinnerInfoCell: UICollectionViewCell {


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = .red
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setupUI(data: Dinner) {
        let parentStackView = setupParentStackView()
        let titleView = setupTitle(title: data.name!, parentStackView: parentStackView)
        let ingredientsView = setupIngredients(ingredients: data.ingredients!, parentStackView: parentStackView)
//        let howToMakeView = setupHowToMake(steps: data.howToMake!, parentStackView: parentStackView)
        let howToMakeView = setupHowToMake(steps: ["Test string 1 lang string som lang string string gyugiyguy uyig gguiuyguyg", "String 2 test string lanf string string string"], parentStackView: parentStackView)
    }
    
    fileprivate func setupParentStackView() -> UIStackView {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.distribution = .equalSpacing
            view.spacing = 0
            view.axis = .vertical
            return view
        }()
        contentView.addSubview(stackView)
        stackView.fillInParent(parent: contentView)
        return stackView
    }
    
    
    // MARK: - Title Section
    
    fileprivate func setupTitle(title: String, parentStackView: UIStackView) -> UIView {
        let viewForTitle: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.heightAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
            return view
        }()
        let titleTextView: UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.textAlignment = .left
            view.text = title
            view.textColor = .white
            view.font = view.font?.withSize(25)
            return view
        }()
        
        viewForTitle.addSubview(titleTextView)
        titleTextView.fillInParent(parent: viewForTitle)
        
        parentStackView.addArrangedSubview(viewForTitle)
        
        return viewForTitle
    }
    
     
    
    // MARK: - Ingredients Section
    
    fileprivate func setupIngredients(ingredients: [String], parentStackView: UIStackView) -> UIView {
        let viewForIngredients: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.backgroundColor = .systemPink
            return view
        }()
        
        let ingredientsStackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.axis = .vertical
            view.distribution = .equalSpacing
            return view
        }()
        
        viewForIngredients.addSubview(ingredientsStackView)
        ingredientsStackView.fillInParent(parent: viewForIngredients)
        
        let titleLabel: UITextView = {
            let view = UITextView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.text = "Ingredients"
            view.font = view.font?.withSize(20)
            view.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
            return view
        }()
        
        
        
        let ingredientsCollection: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.axis = .horizontal
            view.heightAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
            view.backgroundColor = .brown
            view.distribution = .fillEqually
            return view
        }()
        
        ingredientsStackView.addArrangedSubview(titleLabel)
        ingredientsStackView.addArrangedSubview(ingredientsCollection)
        
        let leftIngredientsList: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.axis = .vertical
            view.backgroundColor = .green
            view.distribution = .fillEqually
            return view
        }()
        
        let rightIngredientsList: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.axis = .vertical
            view.backgroundColor = .cyan
            view.distribution = .fillEqually
            return view
        }()
        
        // Ingredients
        
        ingredientsCollection.addArrangedSubview(leftIngredientsList)
        ingredientsCollection.addArrangedSubview(rightIngredientsList)
        
        leftIngredientsList.heightAnchor.constraint(equalTo: ingredientsCollection.heightAnchor).isActive = true
        rightIngredientsList.heightAnchor.constraint(equalTo: ingredientsCollection.heightAnchor).isActive = true
        
        
        // Ingredients Title
        
        titleLabel.topAnchor.constraint(equalTo: ingredientsStackView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: ingredientsStackView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: ingredientsStackView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: ingredientsCollection.topAnchor).isActive = true
        
        ingredientsCollection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        ingredientsCollection.leadingAnchor.constraint(equalTo: ingredientsStackView.leadingAnchor).isActive = true
        ingredientsCollection.trailingAnchor.constraint(equalTo: ingredientsStackView.trailingAnchor).isActive = true
        ingredientsCollection.bottomAnchor.constraint(equalTo: ingredientsStackView.bottomAnchor).isActive = true
        
        for (index, item) in ingredients.enumerated() {
            let ingredientLabel: UITextView = {
                let view = UITextView()
                view.textAlignment = .center
                view.text = item
                view.font = view.font?.withSize(15)
                view.heightAnchor.constraint(equalToConstant: CGFloat(15)).isActive = true
                return view
            }()
            
            if index % 2 == 0 {
                leftIngredientsList.addArrangedSubview(ingredientLabel)
            } else {
                rightIngredientsList.addArrangedSubview(ingredientLabel)
            }
        }
        parentStackView.addArrangedSubview(viewForIngredients)
        return viewForIngredients
    }
    
    
    
    //MARK: - How to make
    
    fileprivate func setupHowToMake(steps: [String], parentStackView: UIStackView) -> UIView {
        let viewForHowToMake: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.backgroundColor = .orange
            view.heightAnchor.constraint(equalToConstant: CGFloat(200)).isActive = true
            return view
        }()
        
        let contentStackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.axis = .vertical
            return view
        }()
        
        viewForHowToMake.addSubview(contentStackView)
        contentStackView.fillInParent(parent: viewForHowToMake)
        
        let howToMakeTitle: UITextView = {
            let view = UITextView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
            view.text = "Steps to make"
            view.font = view.font?.withSize(25)
            return view
        }()
        
        let stepsStackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.backgroundColor = .cyan
            view.axis           = .vertical
            view.distribution   = .fillEqually
            return view
        }()
        

        
        contentStackView.addArrangedSubview(howToMakeTitle)
        contentStackView.addArrangedSubview(stepsStackView)
        

        
//        howToMakeTitle.topAnchor.constraint(equalTo: viewForHowToMake.topAnchor).isActive = true
//        howToMakeTitle.leadingAnchor.constraint(equalTo: viewForHowToMake.leadingAnchor).isActive = true
//        howToMakeTitle.trailingAnchor.constraint(equalTo: viewForHowToMake.trailingAnchor).isActive = true
//        howToMakeTitle.bottomAnchor.constraint(equalTo: stepsStackView.topAnchor).isActive = true
//
//        stepsStackView.topAnchor.constraint(equalTo: howToMakeTitle.bottomAnchor).isActive = true
//        stepsStackView.leadingAnchor.constraint(equalTo: viewForHowToMake.leadingAnchor).isActive = true
//        stepsStackView.trailingAnchor.constraint(equalTo: viewForHowToMake.trailingAnchor).isActive = true
//        stepsStackView.bottomAnchor.constraint(equalTo: viewForHowToMake.bottomAnchor).isActive = true
        
        for step in steps {
            let stepTextField: UITextView = {
                let view = UITextView()
                view.translatesAutoresizingMaskIntoConstraints = true
                view.textAlignment = .left
                view.text = step
                
                view.font = view.font?.withSize(20)
                view.heightAnchor.constraint(equalToConstant: CGFloat(20)).isActive = true
                return view
            }()
            
            stepsStackView.addArrangedSubview(stepTextField)
        }
        
        parentStackView.addArrangedSubview(viewForHowToMake)
        return viewForHowToMake
    }
    


}
