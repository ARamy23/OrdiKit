//
//  UIView+Extensions.swift
//  RamySDK
//
//  Created by Ahmed Ramy on 10/2/20.
//  Copyright © 2020 Ahmed Ramy. All rights reserved.
//

import UIKit
import SnapKit
// MARK: - Properties

public extension UIView {
    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// SwifterSwift: Corner radius of view; also inspectable from Storyboard.
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }

    /// SwifterSwift: Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    /// SwifterSwift: Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, macCatalyst 13.0, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }

    /// SwifterSwift: Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// SwifterSwift: Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var layerShadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    /// SwifterSwift: Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var layerShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// SwifterSwift: Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var layerShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// SwifterSwift: Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var layerShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    /// SwifterSwift: Masks to bounds of view; also inspectable from Storyboard.
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }

    /// SwifterSwift: Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }

    /// SwifterSwift: Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    /// SwifterSwift: Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    /// SwifterSwift: x origin of view.
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    /// SwifterSwift: y origin of view.
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
}

// MARK: - Methods

public extension UIView {
    /// SwifterSwift: Recursively find the first responder.
    func firstResponder() -> UIView? {
        var views = [UIView](arrayLiteral: self)
        var index = 0
        repeat {
            let view = views[index]
            if view.isFirstResponder {
                return view
            }
            views.append(contentsOf: view.subviews)
            index += 1
        } while index < views.count
        return nil
    }

    /// SwifterSwift: Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }

    /// SwifterSwift: Add shadow to view.
    ///
    /// - Note: This method only works with non-clear background color, or if the view has a `shadowPath` set.
    /// See parameter `opacity` for detail.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5). It will also be affected by the `alpha` of `backgroundColor`.
    func addShadow(
        ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    /// SwifterSwift: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }

    /// SwifterSwift: Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    /// SwifterSwift: Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }

    /// SwifterSwift: Load view from nib.
    ///
    /// - Parameters:
    ///   - name: nib name.
    ///   - bundle: bundle of nib (default is nil).
    /// - Returns: optional UIView (if applicable).
    class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

    /// SwifterSwift: Load view of a certain type from nib
    ///
    /// - Parameters:
    ///   - withClass: UIView type.
    ///   - bundle: bundle of nib (default is nil).
    /// - Returns: UIView
    class func loadFromNib<T: UIView>(withClass name: T.Type, bundle: Bundle? = nil) -> T {
        let named = String(describing: name)
        guard let view = UINib(nibName: named, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? T else {
            fatalError("First element in xib file \(named) is not of type \(named)")
        }
        return view
    }

    /// SwifterSwift: Remove all subviews in view.
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// SwifterSwift: Remove all gesture recognizers from view.
    func removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }

    /// SwifterSwift: Attaches gesture recognizers to the view. Attaching gesture recognizers to a view defines the scope of the represented gesture, causing it to receive touches hit-tested to that view and all of its subviews. The view establishes a strong reference to the gesture recognizers.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be added to the view.
    func addGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            addGestureRecognizer(recognizer)
        }
    }

    /// SwifterSwift: Detaches gesture recognizers from the receiving view. This method releases gestureRecognizers in addition to detaching them from the view.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be removed from the view.
    func removeGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            removeGestureRecognizer(recognizer)
        }
    }

    /// SwifterSwift: Scale view by offset.
    ///
    /// - Parameters:
    ///   - offset: scale offset
    ///   - animated: set true to animate scaling (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func scale(
        by offset: CGPoint,
        animated: Bool = false,
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
                self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
            }, completion: completion)
        } else {
            transform = transform.scaledBy(x: offset.x, y: offset.y)
            completion?(true)
        }
    }

    /// SwifterSwift: Shake view.
    ///
    /// - Parameters:
    ///   - direction: shake direction (horizontal or vertical), (default is .horizontal).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - animationType: shake animation type (default is .easeOut).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func shake(
      direction: UIView.ShakeDirection = .horizontal,
        duration: TimeInterval = 1,
      animationType: UIView.ShakeAnimationType = .easeOut,
        completion: (() -> Void)? = nil) {
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }

    /// SwifterSwift: Add Visual Format constraints.
    ///
    /// - Parameters:
    ///   - withFormat: visual Format language.
    ///   - views: array of views which will be accessed starting with index 0 (example: [v0], [v1], [v2]..).
    func addConstraints(withFormat: String, views: UIView...) {
        // https://videos.letsbuildthatapp.com/
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: withFormat,
            options: NSLayoutConstraint.FormatOptions(),
            metrics: nil,
            views: viewsDictionary))
    }

    /// SwifterSwift: Anchor all sides of the view into it's superview.
    func fillToSuperview() {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor)
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor)
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }

    /// SwifterSwift: Add anchors from any side of the current view into the specified anchors and returns the newly added constraints.
    ///
    /// - Parameters:
    ///   - top: current view's top anchor will be anchored into the specified anchor.
    ///   - left: current view's left anchor will be anchored into the specified anchor.
    ///   - bottom: current view's bottom anchor will be anchored into the specified anchor.
    ///   - right: current view's right anchor will be anchored into the specified anchor.
    ///   - topConstant: current view's top anchor margin.
    ///   - leftConstant: current view's left anchor margin.
    ///   - bottomConstant: current view's bottom anchor margin.
    ///   - rightConstant: current view's right anchor margin.
    ///   - widthConstant: current view's width.
    ///   - heightConstant: current view's height.
    /// - Returns: array of newly added constraints (if applicable).
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leftConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        rightConstant: CGFloat = 0,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false

        var anchors = [NSLayoutConstraint]()

        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }

        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }

        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }

        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }

        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }

        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }

        anchors.forEach { $0.isActive = true }

        return anchors
    }

    /// SwifterSwift: Anchor center X into current view's superview with a constant margin value.
    ///
    /// - Parameter constant: constant of the anchor constraint (default is 0).
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    /// SwifterSwift: Anchor center Y into current view's superview with a constant margin value.
    ///
    /// - Parameter withConstant: constant of the anchor constraint (default is 0).
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }

    /// SwifterSwift: Anchor center X and Y into current view's superview.
    func anchorCenterSuperview() {
        // https://videos.letsbuildthatapp.com/
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }

    /// SwifterSwift: Search all superviews until a view with the condition is found.
    ///
    /// - Parameter predicate: predicate to evaluate on superviews.
    func ancestorView(where predicate: (UIView?) -> Bool) -> UIView? {
        if predicate(superview) {
            return superview
        }
        return superview?.ancestorView(where: predicate)
    }

    /// SwifterSwift: Search all superviews until a view with this class is found.
    ///
    /// - Parameter name: class of the view to search.
    func ancestorView<T: UIView>(withClass _: T.Type) -> T? {
        return ancestorView(where: { $0 is T }) as? T
    }
  
    /// SwifterSwift: Returns all the subviews of a given type recursively in the
    /// view hierarchy rooted on the view it its called.
    ///
    /// - Parameter ofType: Class of the view to search.
    /// - Returns: All subviews with a specified type.
    func subviews<T>(ofType _: T.Type) -> [T] {
        var views = [T]()
        for subview in subviews {
            if let view = subview as? T {
                views.append(view)
            } else if !subview.subviews.isEmpty {
                views.append(contentsOf: subview.subviews(ofType: T.self))
            }
        }
        return views
    }
}

// MARK: - Constraints

public extension UIView {
    /// SwifterSwift: Search constraints until we find one for the given view
    /// and attribute. This will enumerate ancestors since constraints are
    /// always added to the common ancestor.
    ///
    /// - Parameter attribute: the attribute to find.
    /// - Parameter at: the view to find.
    /// - Returns: matching constraint.
    func findConstraint(attribute: NSLayoutConstraint.Attribute, for view: UIView) -> NSLayoutConstraint? {
        let constraint = constraints.first {
            ($0.firstAttribute == attribute && $0.firstItem as? UIView == view) ||
                ($0.secondAttribute == attribute && $0.secondItem as? UIView == view)
        }
        return constraint ?? superview?.findConstraint(attribute: attribute, for: view)
    }

    /// SwifterSwift: First width constraint for this view.
    var widthConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .width, for: self)
    }

    /// SwifterSwift: First height constraint for this view.
    var heightConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .height, for: self)
    }

    /// SwifterSwift: First leading constraint for this view.
    var leadingConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .leading, for: self)
    }

    /// SwifterSwift: First trailing constraint for this view.
    var trailingConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .trailing, for: self)
    }

    /// SwifterSwift: First top constraint for this view.
    var topConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .top, for: self)
    }

    /// SwifterSwift: First bottom constraint for this view.
    var bottomConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .bottom, for: self)
    }
}

extension UIView {
  func roundCornersWithMask(_ corners: CACornerMask, radius: CGFloat) {
    self.layer.cornerRadius = radius
    self.layer.maskedCorners = corners
  }
  
  var safeArea: ConstraintBasicAttributesDSL {
      
      #if swift(>=3.2)
          if #available(iOS 11.0, *) {
              return self.safeAreaLayoutGuide.snp
          }
          return self.snp
      #else
          return self.snp
      #endif
  }
  
  class func spacingView(height: CGFloat? = nil) -> UIView {
    let view = UIView()
    view.isUserInteractionEnabled = false
    view.setContentHuggingPriority(.rawValue(249), for: .horizontal)
    view.setContentHuggingPriority(.rawValue(249), for: .vertical)
    view.backgroundColor = .clear

    if let height = height { view.snp.makeConstraints { $0.height.equalTo(height) } }
    
    return view
  }
  
  class func separatorView() -> UIView {
    let view = UIView()
    view.isUserInteractionEnabled = false
    view.backgroundColor = .red
    view.cornerRadius = Dimensions.Separator.cornerRadius
    view.snp.makeConstraints { $0.height.equalTo(Dimensions.Separator.height) }
    
    return view
  }
  
  func fillSuperview() {
    snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  func asImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
  
  /// Closest thing to Sketch's Shadow
  public func addSketchShadow(ofColor color: UIColor = UIColor(hexString: "637381") ?? .red, radius: CGFloat = 10, offset: CGSize = .init(width: 0, height: 4), opacity: Float = 0.1, spread: CGFloat = 0) {
    layer.applySketchShadow(color: color, alpha: opacity, x: offset.width, y: offset.height, blur: radius, spread: spread)
  }
  
  public func embedInShadowView() -> UIView {
    return UIView().then {
      $0.addSubview(self)
      self.fillSuperview()
      $0.addSketchShadow()
    }
  }
  
  @discardableResult
  public func addBlur(style: UIBlurEffect.Style = .extraLight) -> UIVisualEffectView {
      let blurEffect = UIBlurEffect(style: style)
      let blurBackground = UIVisualEffectView(effect: blurEffect)
      addSubview(blurBackground)
      blurBackground.translatesAutoresizingMaskIntoConstraints = false
      blurBackground.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
      blurBackground.topAnchor.constraint(equalTo: topAnchor).isActive = true
      blurBackground.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
      blurBackground.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
      return blurBackground
  }
}

extension CACornerMask {
    public static var topLeading: CACornerMask { return .layerMinXMinYCorner }

    public static var topTrailing: CACornerMask { return .layerMaxXMinYCorner }

    public static var bottomLeading: CACornerMask { return .layerMinXMaxYCorner }

    public static var bottomTrailing: CACornerMask { return .layerMaxXMaxYCorner }
}

public extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0)
  {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
// MARK: - Property Storing

extension UIView: PropertyStoring {
  private struct StoredProperties {
    static var leftBorder: UIView?
    static var rightBorder: UIView?
    static var topBorder: UIView?
    static var bottomBorder: UIView?
  }
}

// MARK: - Borders

public extension UIView {
  enum ViewSide {
    case left
    case right
    case top
    case bottom

    init(name: String) {
      switch name {
      case "top-dashed-line": self = .top
      case "bottom-dashed-line": self = .bottom
      default:
        assertionFailure("Unhandled Edge Name: \(name)")
        self = .top
      }
    }
  }

  var leftBorder: UIView? {
    get {
      return getAssociatedObject(&StoredProperties.leftBorder, defaultValue: nil)
    }
    set {
      objc_setAssociatedObject(self, &StoredProperties.leftBorder, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }

  var rightBorder: UIView? {
    get {
      return getAssociatedObject(&StoredProperties.rightBorder, defaultValue: nil)
    }
    set {
      objc_setAssociatedObject(self, &StoredProperties.rightBorder, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }

  var topBorder: UIView? {
    get {
      return getAssociatedObject(&StoredProperties.topBorder, defaultValue: nil)
    }
    set {
      objc_setAssociatedObject(self, &StoredProperties.topBorder, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }

  var bottomBorder: UIView? {
    get {
      return getAssociatedObject(&StoredProperties.bottomBorder, defaultValue: nil)
    }
    set {
      objc_setAssociatedObject(self, &StoredProperties.bottomBorder, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }

  func removeBorder(_ sides: ViewSide...) {
    for side in sides {
      switch side {
      case .left:
        leftBorder?.removeFromSuperview()
      case .right:
        rightBorder?.removeFromSuperview()
      case .top:
        topBorder?.removeFromSuperview()
      case .bottom:
        bottomBorder?.removeFromSuperview()
      }
    }
  }

  func addBorder(_ sides: ViewSide..., color: UIColor, thickness: CGFloat, offset: UIEdgeInsets = .zero) {
    func addTopBorder() {
      removeBorder(.top)

      let border = UIView()
      border.backgroundColor = color
      topBorder = border
      addSubview(topBorder!)

      topBorder!.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(offset.top)
        make.leading.equalTo(offset.left)
        make.trailing.equalTo(-offset.right)
        make.height.equalTo(thickness)
      }
    }

    func addBottomBorder() {
      removeBorder(.bottom)

      let border = UIView()
      border.backgroundColor = color
      bottomBorder = border
      addSubview(bottomBorder!)

      bottomBorder!.snp.makeConstraints { make in
        make.leading.equalTo(offset.left)
        make.trailing.equalTo(-offset.right)
        make.height.equalTo(thickness)
        make.bottom.equalToSuperview().offset(-offset.bottom)
      }
    }

    func addLeftBorder() {
      removeBorder(.left)

      let border = UIView()
      border.backgroundColor = color
      leftBorder = border
      addSubview(leftBorder!)

      leftBorder!.snp.makeConstraints { make in
        make.leading.equalTo(offset.left)
        make.width.equalTo(thickness)
        make.top.equalToSuperview().offset(offset.top)
        make.bottom.equalToSuperview().offset(-offset.bottom)
      }
    }

    func addRightBorder() {
      removeBorder(.right)

      let border = UIView()
      border.backgroundColor = color
      rightBorder = border
      addSubview(rightBorder!)

      rightBorder!.snp.makeConstraints { make in
        make.trailing.equalTo(-offset.right)
        make.width.equalTo(thickness)
        make.top.equalToSuperview().offset(offset.top)
        make.bottom.equalToSuperview().offset(-offset.bottom)
      }
    }

    for side in sides {
      switch side {
      case .left:
        addLeftBorder()
      case .right:
        addRightBorder()
      case .top:
        addTopBorder()
      case .bottom:
        addBottomBorder()
      }
    }
  }
}

// MARK: - Subviews
extension UIView {
  func searchVisualEffectsSubview() -> UIVisualEffectView? {
    if let visualEffectView = self as? UIVisualEffectView {
      return visualEffectView
    } else {
      for subview in subviews {
        if let found = subview.searchVisualEffectsSubview() {
          return found
        }
      }
    }
    return nil
  }

  /// This is the function to get subViews of a view of a particular type
  /// https://stackoverflow.com/a/45297466/5321670
  func subViews<T: UIView>(type: T.Type) -> [T] {
    var all = [T]()
    for view in subviews {
      if let aView = view as? T {
        all.append(aView)
      }
    }
    return all
  }

  /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
  /// https://stackoverflow.com/a/45297466/5321670
  func allSubViewsOf<T: UIView>(type: T.Type) -> [T] {
    var all = [T]()
    func getSubview(view: UIView) {
      if let aView = view as? T {
        all.append(aView)
      }
      guard !view.subviews.isEmpty else { return }
      view.subviews.forEach { getSubview(view: $0) }
    }
    getSubview(view: self)
    return all
  }
}

// MARK: - Animations

public extension UIView {

  func removeFromSuperViewWithAnimation(with duration: TimeInterval, execute: @escaping (UIView) -> Void, completion: @escaping VoidCallback) {
    UIView.animate(withDuration: duration, animations: {
      execute(self)
    }) { _ in
      self.removeFromSuperview()
      completion()
    }
  }
}


// MARK: - Layout

public enum HuggingPriority: Float {
  case standard = 250
  case moreThanStandard = 251
  case lessThanStandard = 249
  case required = 999
  case must = 1000
}

public enum ResistancePriority: Float {
  case standard = 750
  case moreThanStandard = 751
  case lessThanStandard = 749
  case required = 999
  case must = 1000
}

public extension UIView {

  enum Hugging {
    case vertical(HuggingPriority)
    case horizontal(HuggingPriority)
    case both(HuggingPriority)
  }

  enum Resistance {
    case vertical(ResistancePriority)
    case horizontal(ResistancePriority)
    case both(ResistancePriority)
  }

  func setContentHuggingPriorityCustom(_ hugging: Hugging) {
    switch hugging {
    case .vertical(let value):
      setContentHuggingPriority(.rawValue(value.rawValue), for: .vertical)
    case .horizontal(let value):
      setContentHuggingPriority(.rawValue(value.rawValue), for: .horizontal)
    case .both(let value):
      setContentHuggingPriority(.rawValue(value.rawValue), for: .horizontal)
      setContentHuggingPriority(.rawValue(value.rawValue), for: .vertical)
    }
  }

  func setContentResistancePriorityCustom(_ resistance: Resistance) {
    switch resistance {
    case .vertical(let value):
      setContentCompressionResistancePriority(.rawValue(value.rawValue), for: .vertical)
    case .horizontal(let value):
      setContentCompressionResistancePriority(.rawValue(value.rawValue), for: .horizontal)
    case .both(let value):
      setContentCompressionResistancePriority(.rawValue(value.rawValue), for: .horizontal)
      setContentCompressionResistancePriority(.rawValue(value.rawValue), for: .vertical)
    }
  }
}

// MARK: - Animations
extension UIView {

  func fadeIn() {
    fadeTo(alpha: 1)
  }

  func fadeOut() {
    fadeTo(alpha: 0)
  }
  
  func fadeTo(duration: Double = 0, alpha: CGFloat) {
    UIView.animate(withDuration: duration) {
      self.alpha = alpha
    }
  }
  
}

// MARK:- Draw dashed line
extension UIView {
  func drawDashedLine(on viewSide: ViewSide, color: UIColor, dashLength: NSNumber = 7, gapLength: NSNumber = 7) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = 5
    shapeLayer.lineDashPattern = [dashLength, gapLength]

    switch viewSide {
    case .top:
      let p0 = CGPoint(x: 0, y: self.bounds.minY)
      let p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.minY)
      let path = CGMutablePath()
      path.addLines(between: [p0, p1])
      shapeLayer.path = path
      shapeLayer.name = "top-dashed-line"
    case .bottom:
      let p0 = CGPoint(x: 0, y: self.bounds.maxY)
      let p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)
      let path = CGMutablePath()
      path.addLines(between: [p0, p1])
      shapeLayer.path = path
      shapeLayer.name = "bottom-dashed-line"

    default: break
    }
    self.layer.addSublayer(shapeLayer)
  }
}
