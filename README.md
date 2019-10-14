# 翻轉家事

* App Store 連結： https://apps.apple.com/tw/app/id1481048778

一款紀錄家事項目與完成進度的 app，旨在讓家事變得更有趣，並促進全家人共同參與家庭事務
_____________________________________________________________________________________________________
## 頁面

**《登入 / 註冊》**

* 尊重使用者隱私，不需填入任何使用者資料，僅需設定一組密碼即可註冊（註冊後提供一個英數組合 id 給使用者）

* 利用 `Regular Expression` 限制密碼欄位僅能填入大小寫英文字母及阿拉伯數字

```Swift
func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
                   
  let pattern = "[A-Za-z0-9]"
            
  let regex = NSRegularExpression(pattern)
            
  return regex.matches(string)
}
```
* 密碼加密轉換成亂碼字串後才上傳 database

* 利用 `UICollectionView` 顯示預設成員名稱，與其 delegate function `didSelectItemAt`、`didDeselectItemAt` ，顯示使用者之選擇

* 登入時可利用 QRCode 掃描器，開啟相機掃描 QRCode，或是從相簿選擇 QRCode 檔案，讀取個人 id（有關 QRCode Generator 於家庭頁面詳述）

* 隱私權政策頁面：使用 `WKWebView` 顯示 privacy term link 的內容

![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_00.gif)

<br />

**《今日家事》**

* 顯示當日的家事項目：利用 weekday 搜尋當天的星期所設定之家事項目，
  在 database 中建立一筆當日日期的資料，用以儲存家事項目的完成狀態
  
* 使用 `UICollectionView Drag and Drop API`，讓使用者可以藉由長按、拖曳，
  將家事項目移動至「完成了！」欄位
  
* 實作 `Firebase Cloud Messaging`，每完成一項家事，家人都會收到推播通知

* 使用 `UIViewPropertyAnimator` 完成神燈實現願望畫面之淡入動畫，
  並讓動畫可藉由使用者點選 ```skip 按鈕``` 後提前結束
  
* 使用者遇到問題時，可點選右下角小圖查看版號、利用`MFMailComposeViewController`寄信給我們
  
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/IMG_5488.png)


![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_01.gif)
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/IMG_5506.jpg)

<br />

**《查看、刪除、新增家事》**

* 查看與刪除：
  * 使用 `UITableView` 搭配兩種 `UITableViewCell`（有設定家事與未設定家事）顯示一週家事，包括家事內容、小圖、疲勞值
  * 使用 `enum` 管理預設的家事項目，並將其各搭配一個小圖
  * 刪除家事時，`UITableView` `reloadData()`，當日最後一項家事被刪除時，會直接更新成顯示未設定家事的 cell
  * 刪除當天星期之家事，會同步從當天的「今日家事」列表中移除
  
* 新增：
  * 預設八種家事標籤，使用 `UICollectionView` 搭配 delegate function `didSelectItemAt`、`didDeselectItemAt`，使用者也可以新增、刪除自訂家事標籤
  * 時間以星期日期為單位，使用 `UIPickerView` 作為選擇星期之工具；為了畫面和諧，其 `viewForRow` 是由 `UILabel` 建構而成
  * 使用 `UISlider` 作為設定疲勞值之工具；使用者滑動時，顯示對應的數值（整數數字）
  * 防呆處理：
    - 點選「新增家事標籤」時，若未輸入任何內容，提醒使用者 UITextField 不可留白
    - 點選「完成」時，若尚未選擇家事標籤，提醒使用者
    - 新增相同文字的家事標籤時，提醒使用者標籤已經存在
  * 重複設定家事之處理：若同天有相同項目的家事再度被設定，會更新此家事之疲勞值為新設定的值，並通知使用者此變更
  * 新增當天星期之家事，會同步更新當天的「今日家事列表」未完成欄位
  * 利用 `UITextField` 的 delegate function `shouldChangeCharactersIn` 限制使用者新增家事標籤時的字數
  
 ![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_02.gif)
 ![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/IMG_5489.png)

<br />

**《神燈許願》** 

* 許願：
  * 利用 `CABasicAnimation(keyPath: "transform.rotation")`，製作點擊神燈時的搖動動畫
  * 利用 `UITextView` 的 delegate function `shouldChangeTextIn` 限制使用者許願內容的字數

* 查看神燈願望：
  * 利用 `UICollectionViewLayout` 的 sub class 創建一個瀑布流(waterful)的 custom layout，使願望的畫面分佈更符合主題的「神燈奇幻感」
  * 使用 3 種字體大小，並讓 cell 的高度配合字體大小變化，增加效果
  
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_03.gif)
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/IMG_5490.png)

<br />

**《家庭》** 

* 基本資料
  * 顯示個人稱呼、id、家庭（家庭名稱與成員、邀請中的成員)、收到家庭邀請時顯示同意或拒絕選項
  * 利用 `UIPasteboard.general` 實現點擊 id 複製的功能
  * 利用 `CIQRCodeGenerator` 實現將 id 字串轉換為 QRCode，並利用 `UIGraphicsImageRenderer`實現將 QRCode 存進手機相簿之功能
  
  <br />
  
  ```Swift
  func generateQRCode(from string: String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: QRCodeString.qrFilterName) {
            
            filter.setValue(data, forKey: QRCodeString.qrFilterValue)
            
            let transform = CGAffineTransform(scaleX: 8, y: 8)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    ```
    
    ```Swift
    func saveQRCodeInfoImage() {
        
        let renderer = UIGraphicsImageRenderer(size: QRCodeInfoView.bounds.size)
        
        let image = renderer.image(actions: { [weak self] (context) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.QRCodeInfoView.drawHierarchy(in: strongSelf.QRCodeInfoView.bounds,
                                                    afterScreenUpdates: true)
        })
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSavingResult), nil)
    }
    ```
* 加入/ 退出家庭：
  * 點選同意家庭邀請即加入新家庭，家事一併更新為新家庭的內容
  * 若所在家庭非註冊時的家庭，顯示 `退出家庭` 按鈕；若選擇退出，則回到註冊時的家庭，家事一樣同步更新
  
* 新增成員
  * 可利用輸入成員 id 搜尋成員並發送邀請
  * 利用 `AVFoundation` 的 `AVCaptureDevice` 製作QRCode掃瞄器，並利用 `AVMetadataObject` 將 QRCode 轉換回字串，實現掃描 QRCode 搜尋成員 id 的功能
  * 利用 `UIImagePickerController` 開啟相簿，並結合 `CIDetector` 實現搜尋並解析圖片中 QRCode 所儲存的資訊（成員 id）之功能
  * 防呆處理：
    - 受邀人為自己時，提醒使用者
    - 重複邀請同一人時，提醒使用者，並不重複邀請
    - 受邀人已是家庭成員時，提醒使用者，並不發送邀請
    
* 變更名稱
  * 可變更個人稱呼及所在家庭的名稱
  * `UIAlertController` 加上 `UITextField`


![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/IMG_5491.png)
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_04.gif)
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_05.gif)
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_06.gif)
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_07.gif)

<br />

### 使用套件
* IQKeyboardManagerSwift
* JGProgressHUD
* ESPullToRefresh
* RNCryptor
