//
//  ActionPopupController.swift
//  house
//
//  Created by Michael Arbuckle on 12/23/16.
//  Copyright © 2016 Michael Arbuckle. All rights reserved.
//

import Foundation
import UIKit

final class ActionPopupController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    fileprivate let actionReuseIdentifier = "ActionCVCell"
    fileprivate let alertReuseIdentifier = "AlertCVCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate var selectedPhotos = [Action]()
    fileprivate let shareTextLabel = UILabel()
    var measurand = Measurand()
    
    @IBOutlet var collectionView : UICollectionView!

   
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("init nibname ",nibName)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // data = ["a", "b", "c"]
        
        // This works, by nib
     //   let nib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        collectionView?.register(ActionCVCell.self, forCellWithReuseIdentifier: actionReuseIdentifier)
        collectionView?.register(AlertCVCell.self, forCellWithReuseIdentifier: alertReuseIdentifier)
        collectionView?.register(ActionsHeaderView.self,  forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ActionHeaderView")  //
        // This fails, by class
        //collectionView?.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 //actions.count
    }

    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ActionHeaderView",
                                                                             for: indexPath) as! ActionsHeaderView
            headerView.label.text = self.measurand.name
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print ("cellFor path section = %d  row = %d ",indexPath.section,indexPath.row)
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: actionReuseIdentifier, for: indexPath) as! ActionCVCell
        let action = actionForIndexPath(indexPath: indexPath)
        
        
        print("cellFor Action = %@",action.name)
        //1
       // cell.activityIndicator.stopAnimating()
        
        cell.name.text = action.name!
        cell.type.text = action.type!
        
        //3
        
        cell.imageView.image = UIImage(contentsOfFile: "washing-machine.png")
        
        
        //cell.activityIndicator.startAnimating()
        
        
        
        return cell
    }
    
        // MARK: - UICollectionViewDelegate
        func collectionView(_ collectionView: UICollectionView,
                                     shouldSelectItemAt indexPath: IndexPath) -> Bool {
            
            return false
        }
        
        func collectionView(_ collectionView: UICollectionView,
                                     didSelectItemAt indexPath: IndexPath) {
            
            let photo = actionForIndexPath(indexPath: indexPath)
            selectedPhotos.append(photo)
        }
        
        func collectionView(_ collectionView: UICollectionView,
                                     didDeselectItemAt indexPath: IndexPath) {
            
            
            let photo = actionForIndexPath(indexPath: indexPath)
            
            if let index = selectedPhotos.index(of: photo) {
                selectedPhotos.remove(at: index)
                
            }
        }
    
}

var actions:[Action] = {
    
    return [
        Action(name: "Ventilation",type:"ventilate", image: "fan"),
       Action(name: "Timeline",type:"", image:"lake" ),
       Action(name: "Send Alert",type:"", image: "harbour" ),
       Action(name: "Add Rule", type:"", image: "buda" )
    ]
    
}()

private extension ActionPopupController {
    func actionForIndexPath(indexPath: IndexPath) -> Action {
        
        print("actionForIncex",actions.count)
        
        return actions[(indexPath as NSIndexPath).row]
    }
}






extension ActionPopupController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
/*
extension UICollectionView {
    
    func register<T: UICollectionViewCell where T: ReusableView>(_: T.Type) {
        registerClass(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UICollectionViewCell where T: ReusableView, T: NibLoadableView>(_: T.Type) {
        let bundle = NSBundle(forClass: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        registerNib(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell where T: ReusableView>(forIndexPath indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithReuseIdentifier(T.defaultReuseIdentifier, forIndexPath: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}
*/
