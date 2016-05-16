import Foundation

func LS(string: String) -> String {
    return NSLocalizedString(string, comment: "")
}

func loadViewFromNib(nibName: String, owner: AnyObject) -> UIView {
    let bundle = NSBundle(forClass: owner.dynamicType)
    let nib = UINib(nibName: nibName, bundle: bundle)
    let view = nib.instantiateWithOwner(owner, options: nil)[0] as! UIView

    return view
}
