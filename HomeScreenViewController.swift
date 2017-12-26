
import UIKit
import Firebase

var date=[Date(),Date()]
//
var testImage = ""
var globalPrice = ""
var globalImage = ""
var globalUser = ""
var globalPhone = ""
var globaEmail = ""
var globalTitle = ""
var globalUserID = ""
var myImage :[UIImage]!

class HomeScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var bannerPageController: UIPageControl!
    var users = [User]()
    var productPrice = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5"]
    var productImage = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5"]
    var productUsername = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5"]
    var productPhone = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5"]
    var productEmail = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5"]
    var productTitle = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5"]
var productUserID = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5"]
   
    var index:Int!
    let cellIdentifier = "cell"
    var databaseRef: DatabaseReference!
    var ref: DatabaseReference!
    var timer: Timer!
    var updateCounter: Int!

    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUser()
        updateCounter = 0
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(HomeScreenViewController.updateTimer), userInfo: nil, repeats: true)

        
    }
    override func viewWillAppear(_ animated: Bool) {
        getNumberOfAllImage()
        getNumberOfuserImage()
        loadAddCartNumber()
    }
    override func viewWillLayoutSubviews() {
        //fetchUser()
//        getNumberOfAllImage()
//        getNumberOfuserImage()
//        loadAddCartNumber()
    }
    func updateTimer() {
        if(updateCounter <= 3){
            bannerPageController.currentPage = updateCounter
            bannerImageView.image = UIImage(named: String(updateCounter+1) + ".jpg")
            updateCounter = updateCounter+1
            
        }
        else{
            updateCounter = 0
        }
    }

    // collection data view of new product 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_newproduct", for: indexPath) as! newProductCollectionViewCell

        let user = users[indexPath.row]
        
        if let imageUrl = user.profileImageUrl {
            self.productImage[indexPath.row] = imageUrl
                        let imageUrl = URL(string: imageUrl)!
                        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                            if let data = data {
                                print("the respone data is")
                                print(data)
                                let image = UIImage(data: data)
                                
                                DispatchQueue.main.async {
                                    if image != nil {
                                        print("return true ")
                                        //self.bannerImageView.image = image
                                        cell.newProductImageView.image = image
                                        cell.newProductlabelView.text = user.price! + "$"
                                        
                                        if let price = user.price {
                                            self.productPrice[indexPath.row] = price
                                        }
                                        if let username = user.username {
                                            self.productUsername[indexPath.row] = username
                                        }
                                        if let userphone = user.phone {
                                            self.productPhone[indexPath.row] = userphone
                                        }
                                        if let email = user.email {
                                            self.productEmail[indexPath.row] = email
                                        }
                                        if let title = user.title{
                                            self.productTitle[indexPath.row] = title
                                        }
                                        if let UserID = user.UserID {
                                            self.productUserID[indexPath.row] = UserID
                                        }
                                        
                                    } else {
                                        print("return default ")
                                        self.bannerImageView.image = #imageLiteral(resourceName: "default_image_select")
            
                                    }
                                }
                            }
                        }
                        task.resume()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        print(self.productUsername[indexPath.row])
        print(self.productPrice[indexPath.row])
         print(self.productPhone[indexPath.row])
        print(self.productImage[indexPath.row])
        globalUserID = self.productUserID[indexPath.row]
        globalUser = self.productUsername[indexPath.row]
        globalPrice = self.productPrice[indexPath.row]
        globalPhone = self.productPhone[indexPath.row]
        globaEmail = self.productEmail[indexPath.row]
        globalTitle = self.productTitle[indexPath.row]
        globalImage = self.productImage[indexPath.row]
        
        
        
        //let detailInf = MyAppDetail.shared
        //detailInf.price = self.indextItem[indexPath.row]
        //detailInf.image = self
        
        self.performSegue(withIdentifier: "segue_detail", sender: self)
    }
   
    func fetchUser(){
        getNumberOfAllImage()
        getNumberOfuserImage()
        //************************************************
        // for a in 1...MyApp.shared.numberOfAllImage {
        Database.database().reference().child("AllimageInformation").observe(.childAdded, with: { (snapshot) in
            print("start print fetch user: ")
            let user = User()
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let price = value?["price"] as? String ?? ""
            let useremail  = value?["email"] as? String ?? ""
            let userphone = value?["phone"] as? String ?? ""
            var productImage = value?["image"] as? String ?? ""
            var productTitle = value?["productTitle"] as? String ?? ""
            var userID = value?["UserID"] as? String ?? ""
            //var userImage = ""
            
            //userImage = value?["image\(a)"] as? String ?? "default_image_select"
            
            print("Username:",username,"email:",useremail,"Image:",productImage)
            
            user.profileImageUrl = productImage
            user.UserID = userID
            user.title = productTitle
            user.username = username
            user.price = price
            user.phone = userphone
            user.email = useremail
            self.users.append(user)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }, withCancel: nil)
        // }
        //************************************
        
    }
    func getNumberOfAllImage(){
        ref = Database.database().reference()
        ref.child("numberOfAllImage").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! Int? ?? 0
            let result = value//Decimal(string: value)
            print("number of all image is:")
            print(value)
            var i = result
            print(i)
            let myApp = MyApp.shared
            myApp.numberOfAllImage = result
            

            
        }){(error) in
            print(error.localizedDescription)
        }
    }
  
    func getNumberOfuserImage(){
        if Auth.auth().currentUser != nil {
            let uID = Auth.auth().currentUser?.uid
            let imageName = NSUUID.init(uuidString: uID!)
            ref = Database.database().reference()
            ref.child("tblUsers").child(uID!).child("numberOfproduct").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! Int? ?? 0
                let result = value//Decimal(string: value)
                print("myPersonal image is:")
                print(value)
                var i = result
                print(i)
                let myApp = MyApp.shared
                myApp.numberOfproduct = result // personal product number
                
            }){(error) in
                print(error.localizedDescription)
            }
            
        } else {
            
        }
       
    }
    
    func loadAddCartNumber(){
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                let uID = Auth.auth().currentUser?.uid
                self.ref = Database.database().reference()
                self.ref.child("userAddCart").child(uID!).child("addCartNumber").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Int? ?? 0
                    let result = value//Decimal(string: value)
                    print("number add cart image:")
                    print(value)
                    let myApp = MyApp.shared
                    myApp.addCartNumber = value // number of cart
                    print("current add cart number is:",value)
                    
                }){(error) in
                    print(error.localizedDescription)
                }
            }
        }else{
            
        }
    }
    
    
    /// no use
//    func downloadImage(){
//        for a in 0...2 {
//            let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
//            let profileRef = Storage.storage().reference(withPath: "productImages/\(a+1)\(profileImageFileName)")
//            profileRef.getData(maxSize: 102240000) { (imageData, error) in
//                if error == nil {
//                    print("Load profile from firebase success",imageData)
//
//                    let image = UIImage(data: imageData!)
//                    DispatchQueue.main.async {
//                        if a == 0{
//                            //self.image1View.image = image
//                        }
//                        if a == 1 {
//                            //self.image2View.image = image
//                        }
//                        if a == 2 {
//                            //self.image3View.image = image
//                        }
//
//                    }
//                }
//                else {
//                    print("Load profile from Firebase fail:", error?.localizedDescription)
//                }
//            }
//        }
//    }
    
    
}
//cell.newProductImageView.image = UIImage(named: image1[indexPath.row] + ".jpg")
//let viewCost = cost[indexPath.row]
//cell.newProductlabelView.text = "US $\(viewCost)"

//cell.newProductImageView.image = UIImage(named: "default_image_select")

//        let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
//        //let profileRef = Storage.storage().reference(withPath: "productImages/\(indexPath.row+1)\(profileImageFileName)")
//        let profileRef = Storage.storage().reference(withPath: "users_profile_image/")
//        profileRef.getData(maxSize: 102240000) { (imageData, error) in
//            if error == nil {
//                print("Load profile from firebase success",imageData)
//
//                let image = UIImage(data: imageData!)
//                DispatchQueue.main.async {
//                    cell.newProductImageView.image = image
//
//                }
//            }
//            else {
//                print("Load profile from Firebase fail:", error?.localizedDescription)
//            }
//        }
