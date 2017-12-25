
import UIKit
import Firebase
// customer information
var homeIndex: Int = 0
var title=["iPhone5","Computer Dell"]
var newImage:[String] = ["5","6","7","8","9","10","11","12","13","14","Nokia","Iphone5"]
var name=["Chrin Chiva","Ngoun Rithy"]
var email=["chivachrin@gmail.com","Rithy@gmail.com"]
var username=["chrinchiva","nhounrithy"]
var password=["123","123"]
var telephone1=["010767276","086266007"]
var telephone2=["",""]
var cost=[120.0,100.0,300.0,150.0]
var id=["1","2","3"]
var address=["kakab, pour senchey","chomka mon, sensok"]
var newOrold=[true,false]
var description=["ផលិតផលនេះត្រូវបានប្រើចាប់តាំងពីខែមករាឆ្នាំ២០១៦​, នូវថ្មី%","ផលិតផលនេះត្រូវបានប្រើចាប់តាំងពីខែមករាឆ្នាំ២០១៥, នូវថ្មី៥០%"]
var image1:[String] = ["5","6"]
var image2:[String] = ["","7"]
var image3:[String]=["7","8"]
var image4:[String]=["8","9"]
var image5:[String]=["9","10"]
var shipping=[0.00,0.50,0.00,1.00,0.00]
var category=["Phone", "Computer PC", "Clothes", "Laptop", "Bag", "Motor"]
 var province:[String] = ["Phnom Penh","Sihanouk","Takeo","Kandal","Battombong","Prey Veng","Kom Pong Speu","Svay Reang","Phnom Penh","Sihanouk","Takeo","Kandal","Battombong","Prey Veng","Kom Pong Speu","Svay Reang"]
var date=[Date(),Date()]
//
var testImage = ""

class HomeScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var bannerPageController: UIPageControl!
    var users = [User]()
    var indextItem = ["1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5","1","2","3","4","5"]
    var index:Int!
    let cellIdentifier = "cell"
    var databaseRef: DatabaseReference!

    var timer: Timer!
    var updateCounter: Int!

    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        updateCounter = 0
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(HomeScreenViewController.updateTimer), userInfo: nil, repeats: true)

        
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
                                        cell.newProductlabelView.text = user.username
                                        if let storename = user.username {
//                                            self.indextItem.append(storename)
//                                            let item = self.indextItem[indexPath.row]
                                            self.indextItem[indexPath.row] = storename
                                            print("************* Array *******************:", self.indextItem[indexPath.row])
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
        print(self.indextItem[indexPath.row])
        self.performSegue(withIdentifier: "segue_homedetail", sender: self)
    }
   
    func fetchUser(){
        Database.database().reference().child("userprofiles").observe(.childAdded, with: { (snapshot) in
            print("start print fetch user: ")
            let user = User()
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                let useremail  = value?["email"] as? String ?? ""
                let userphone = value?["phone"] as? String ?? ""
                let userImage = value?["image"] as? String ?? "default_image_select"
                let iemail = useremail
                let iphone = userphone
                let iuser = username
            var iimage = userImage
            print("Username:",iuser,"email:",iemail,"Image:",iimage)
            
            // *****************************************
            //let imageToCache = iimage
            user.profileImageUrl = iimage
            //imageCache.setObject(imageToCache, forKey: <#T##AnyObject#>)
            //user.profileImageUrl = imageToCache
            
            user.username = iuser
            self.users.append(user)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }, withCancel: nil)
    }
    
    
    
    
    /// no use
    func downloadImage(){
        for a in 0...2 {
            let profileImageFileName = Auth.auth().currentUser!.uid + ".jpg"
            let profileRef = Storage.storage().reference(withPath: "productImages/\(a+1)\(profileImageFileName)")
            profileRef.getData(maxSize: 102240000) { (imageData, error) in
                if error == nil {
                    print("Load profile from firebase success",imageData)
                    
                    let image = UIImage(data: imageData!)
                    DispatchQueue.main.async {
                        if a == 0{
                            //self.image1View.image = image
                        }
                        if a == 1 {
                            //self.image2View.image = image
                        }
                        if a == 2 {
                            //self.image3View.image = image
                        }
                        
                    }
                }
                else {
                    print("Load profile from Firebase fail:", error?.localizedDescription)
                }
            }
        }
    }
    
    
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
