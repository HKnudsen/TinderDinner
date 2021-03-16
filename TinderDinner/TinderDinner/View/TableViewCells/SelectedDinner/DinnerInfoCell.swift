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
        let howToMakeView = setupHowToMake(steps: data.howToMake!, parentStackView: parentStackView)
        let allergensView = setupAllergensView(data: data.allergens!, parentStackView: parentStackView)
        let creditsView = setupCredits(origin: data.origin!, parentStackView: parentStackView)
        print("Height: \(contentView.frame.height)")
        print("Number of elements: \(data.ingredients!.count + data.howToMake!.count)")
    }
    
    fileprivate func setupParentStackView() -> UIStackView {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
//            view.distribution = .equalSpacing
            view.distribution = .fill

            view.spacing = 50
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
            view.heightAnchor.constraint(equalToConstant: CGFloat(75)).isActive = true
            return view
        }()
        let titleTextView: UILabel = {
            let view = UILabel()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.textAlignment = .left
            view.text = title
            view.textColor = .white
            view.isUserInteractionEnabled = false
            view.font = view.font?.withSize(30)
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
            view.heightAnchor.constraint(equalToConstant: CGFloat((40 * ingredients.count) + 50)).isActive = true
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
            view.isUserInteractionEnabled = false
            view.font = view.font?.withSize(25)
            view.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
            return view
        }()
        
        
        
        let ingredientsCollection: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.axis = .vertical
            view.heightAnchor.constraint(equalToConstant: CGFloat(30 * ingredients.count)).isActive = true
            view.backgroundColor = .brown
            view.distribution = .fillEqually
            
            return view
        }()
        
        ingredientsStackView.addArrangedSubview(titleLabel)
        ingredientsStackView.addArrangedSubview(ingredientsCollection)
        

        
        // Ingredients
        
        
        
        // Ingredients Title
        
        titleLabel.topAnchor.constraint(equalTo: ingredientsStackView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: ingredientsStackView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: ingredientsStackView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: ingredientsCollection.topAnchor).isActive = true
        
        ingredientsCollection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        ingredientsCollection.leadingAnchor.constraint(equalTo: ingredientsStackView.leadingAnchor).isActive = true
        ingredientsCollection.trailingAnchor.constraint(equalTo: ingredientsStackView.trailingAnchor).isActive = true
        ingredientsCollection.bottomAnchor.constraint(equalTo: ingredientsStackView.bottomAnchor).isActive = true
        
        for item in ingredients {
            let ingredientLabel: UITextView = {
                let view = UITextView()
                view.textAlignment = .center
                view.text = item
                view.font = view.font?.withSize(20)
                view.textAlignment = .left
                view.isScrollEnabled = false
                view.isUserInteractionEnabled = false
                view.heightAnchor.constraint(equalToConstant: CGFloat(30)).isActive = true
                return view
            }()
            
            ingredientsCollection.addArrangedSubview(ingredientLabel)
            
            
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
            view.heightAnchor.constraint(equalToConstant: CGFloat((steps.count * 40) + 50)).isActive = true
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
            view.isUserInteractionEnabled = false
            return view
        }()
        
        let stepsStackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.backgroundColor    = .cyan
            view.axis               = .vertical
            view.distribution       = .fillEqually
            view.spacing            = 0
            return view
        }()
        

        
        contentStackView.addArrangedSubview(howToMakeTitle)
        contentStackView.addArrangedSubview(stepsStackView)
        
        for step in steps {
            let stepTextField: UITextView = {
                let view = UITextView()
                view.translatesAutoresizingMaskIntoConstraints = true
                view.textAlignment = .left
                view.text = step
                view.font = view.font?.withSize(20)
                view.isUserInteractionEnabled = false
                view.heightAnchor.constraint(equalToConstant: CGFloat(40)).isActive = true
                return view
            }()
            
            stepsStackView.addArrangedSubview(stepTextField)
        }
        
        parentStackView.addArrangedSubview(viewForHowToMake)
        return viewForHowToMake
    }
    
    fileprivate func setupAllergensView(data: String, parentStackView: UIStackView) -> UIView {
        let substrings = data.components(separatedBy: ";")
        
        let viewForAllergens: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.backgroundColor = .orange
            view.heightAnchor.constraint(equalToConstant: CGFloat((40 * substrings.count) + 50)).isActive = true
            return view
        }()
        
        let allergensStackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.axis = .vertical
            return view
        }()
        
        viewForAllergens.addSubview(allergensStackView)
        parentStackView.addArrangedSubview(viewForAllergens)
        allergensStackView.fillInParent(parent: viewForAllergens)
        
        let allergensTitle: UITextView = {
            let view = UITextView()
            view.text = "Allergens"
            view.translatesAutoresizingMaskIntoConstraints = true
            view.font = view.font?.withSize(CGFloat(25))
            view.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
            return view
        }()
        
        let allergensListStackView: UIStackView = {
            let view = UIStackView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.heightAnchor.constraint(equalToConstant: CGFloat(substrings.count * 40)).isActive = true
            view.axis = .vertical
            view.distribution = .fillEqually
            return view
        }()
        
        allergensStackView.addArrangedSubview(allergensTitle)
        allergensStackView.addArrangedSubview(allergensListStackView)
        
        for allergen in substrings {
            let allergenTextView: UITextView = {
                let view = UITextView()
                view.translatesAutoresizingMaskIntoConstraints = true
                view.text = allergen
                view.font = view.font?.withSize(CGFloat(20))
                view.isScrollEnabled = false
                view.heightAnchor.constraint(equalToConstant: CGFloat(40)).isActive = true
                return view
            }()
            
            allergensListStackView.addArrangedSubview(allergenTextView)
            
        }
        
//        allergensTitle.topAnchor.constraint(equalTo: viewForAllergens.topAnchor).isActive = true
//        allergensTitle.leadingAnchor.constraint(equalTo: viewForAllergens.leadingAnchor).isActive = true
//        allergensTitle.trailingAnchor.constraint(equalTo: viewForAllergens.trailingAnchor).isActive = true
//        allergensTitle.bottomAnchor.constraint(equalTo: allergensListStackView.topAnchor).isActive = true
        
        return viewForAllergens
        
    }
    
    fileprivate func setupCredits(origin: String, parentStackView: UIStackView) -> UIView {
        let viewForCredits: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.heightAnchor.constraint(equalToConstant: CGFloat(50)).isActive = true
            return view
        }()
        
        let creditText: UITextView = {
            let view = UITextView()
            view.translatesAutoresizingMaskIntoConstraints = true
            view.text = "Credit: \(origin)"
            view.font = view.font?.withSize(CGFloat(20))
            view.isScrollEnabled = false
            view.isSelectable = false
            return view
        }()
        
        viewForCredits.addSubview(creditText)
        creditText.fillInParent(parent: viewForCredits)
        
        parentStackView.addArrangedSubview(viewForCredits)
        
        
        return viewForCredits
    }
    


}
