//
//  MypageViewController.swift
//  KICK
//
//  Created by cheshire on 2023/09/04.
//
import Foundation
import UIKit

class EditProfileViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let userData = UserManager.shared
    
    var user: User?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addProfilePhoto: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userContact: UITextField!
    @IBOutlet weak var userCredit: UITextField!
    @IBOutlet weak var userLicense: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = userData.getUser(id: "사용자 ID")
        setupProfilePhoto()
        updateUserInfo()
    }
    
    // 등록버튼 클릭시 유저 데이터 저장
    @IBAction func editProfile(_ sender: Any) {
        print("등록버튼이 눌렸습니다")
        guard let newName = userName.text,
              let newContact = userContact.text,
              let newCredit = userCredit.text,
              let newLicense = userLicense.text else {
            return dismiss(animated: true, completion: nil)
        }
        user?.userName = newName
        user?.userContact = newContact
        user?.userCredit = newCredit
        user?.userLicense = newLicense
        
        defaults.set(newName, forKey: "userName")
        defaults.set(newContact, forKey: "userContact")
        defaults.set(newCredit, forKey: "userCredit")
        defaults.set(newLicense, forKey: "userLicense")
        
        print("사용자 정보가 수정되었습니다.")
        print("이름: \(newName) | 연락처: \(newContact) | 카드정보: \(newCredit) | 운전면허: \(newLicense)")
        print("-----------------------")
        print("마이페이지로 돌아갑니다")
        
        if let updatedUser = user {
//            userData.saveUser(user: updatedUser)
            UserManager.shared.currentUser = updatedUser
        }
        
        // 저장후 마이페이지로 되돌아가는 화면전환 실행
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateUserInfo() {
        if let user = user {
            userName.text = user.userName
            userContact.text = user.userContact
            userCredit.text = user.userCredit
            userLicense.text = user.userLicense
        }
    }
    
    // 회원탈퇴버튼 클릭시 유저정보 삭제
    @IBAction func removeUser(_ sender: Any) {
        // 탈퇴의사를 재확인 하는 알럿 표시
        let deleteAlert = UIAlertController(title: "의사 재확인", message: "정말로 탈퇴하시겠습니까?", preferredStyle: .alert)
        // '아니오(철회)' 클릭시
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        deleteAlert.addAction(cancelAction)
        present(deleteAlert, animated: true)
        
        // '네' 클릭시
        let okAction = UIAlertAction(title: "네", style: .default, handler: nil)
        deleteAlert.addAction(okAction)
        // 사용자 정보 삭제 후
        userData.deleteUser(id: "사용자 ID")
        // 로그인 페이지로 이동
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }
    
    // 취소버튼 클릭시 MyPage로 화면전환
    @IBAction func backToMypage(_ sender: Any) {
        if self.presentingViewController != nil {
            self.dismiss(animated: true)
        } else if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // 프로필 이미지 등록
    func setupProfilePhoto() {
        addProfilePhoto?.addTarget(self, action: #selector(uploadPhoto), for: .touchUpInside)
    }
    // 사진이 표시되는 프레임
    func photoFrame() {
        let safeArea = view.safeAreaLayoutGuide; NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    // 사진 업로드
    @objc func uploadPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
}

// 이미지 피커를 사용하기 위한 확장
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage =
            info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
