//
//  Preview.swift
//  Boolti
//
//  Created by Miro on 8/27/24.
//
import SwiftUI

#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }

    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif

/// 아래와 같이 PreView를 활용하면 됨
/*
 import SwiftUI

 struct PreView: PreviewProvider {
     static var previews: some View {
         // Preview를 보고자 하는 ViewController를 넣으면 됩니다.
         HomeViewController().toPreview()
     }
 }
 */
