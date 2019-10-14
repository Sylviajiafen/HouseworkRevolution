# 翻轉家事

一款紀錄家事項目與完成進度的 app，旨在讓家事變得更有趣，並促進全家人共同參與家庭事務

<a href="https://apps.apple.com/app/id1481048778"><img src="https://i.imgur.com/Pc1KdHw.png" width="100"></a>

_____________________________________________________________________________________________________

## 頁面

> **《登入 / 註冊》**

* 尊重使用者隱私，不需填入任何使用者資料，僅需設定一組密碼即可註冊

* 利用 `Regular Expression` 限制密碼欄位僅能填入大小寫英文字母及阿拉伯數字

* 利用 `UICollectionView` delegate function `didSelectItemAt`、`didDeselectItemAt` 製作預設家庭成員名稱，方便使用者加速註冊流程

* 登入時可利用 QRCode 掃描器，開啟相機掃描 QRCode，或是從相簿選擇 QRCode 檔案，讀取個人 id

* 隱私權政策頁面：使用 `WKWebView` 顯示 privacy term link 的內容

![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_00.gif)


> **《今日家事》**

* 顯示當日的家事項目：利用 weekday 搜尋當天的星期所設定之家事項目，
  在 database 中建立一筆當日日期的資料，並儲存家事項目的完成狀態
  
* 使用 `UICollectionView Drag and Drop API`，讓使用者可以藉由長按、拖曳，
  將家事項目移動至「完成了！」欄位
  
* 每完成一項家事，家人都會收到推播通知：實作 `Firebase Cloud Messaging`

* 使用 `UIViewPropertyAnimator` 完成神燈實現願望時的畫面淡入動畫，
  並讓動畫可藉由使用者點選 ```skip 按鈕``` 後提前結束。
  
* 使用者遇到問題時，可點選右下角小圖查看版號，與寄信給我們（利用`MFMailComposeViewController`）
  
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/IMG_5488.png)


![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_01.gif)
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/IMG_5506.jpg)


> **《查看、刪除、新增家事》**

* 查看與刪除：
  * 使用 `UITableView` 搭配兩種 `UITableViewCell`（有設定家事與未設定家事）顯示星期一至星期五的家事：包括搭配小圖、疲勞值
  * 使用 `enum` 管理預設的家事項目，並將其各搭配一個小圖
  * 刪除某個星期的最後一項家事時，`UITableView` 直接 `reloadData()`，讓 `UITableViewCell` 直接更新成顯示未設定家事的 cell
  * 刪除當天星期之家事，會同步從當天的「今日家事」列表中移除
  
* 新增：
  * 預設八種家事標籤，使用 `UICollectionView` 搭配 delegate function `didSelectItemAt`、`didDeselectItemAt`，也讓使用者可以新增、刪除自訂家事標籤
  * 使用 `UIPickerView` 作為選擇星期之工具；為了畫面和諧，其 `viewForRow` 是用 `UILabel` 建構而成
  * 使用 `UISlider` 作為設定疲勞值之工具；使用者滑動時，顯示對應的數值（整數數字）
  * 防呆處理：
    - 點選「新增家事標籤」時，UITextField 不可留白
    - 點選「完成」時，不可無選擇的家事俵千
    - 新增相同文字的家事標籤時，提醒使用者標籤已經存在
  * 重複設定家事之處理：若同天有相同項目的家事被設定第二次或以上，會更新此家事之疲勞值為新設定的值，並通知使用者
  * 新增當天星期之家事，會同步更新當天的「今日家事列表」未完成欄位
  * 使用 `UITextField` 的 delegate function `shouldChangeCharactersIn` 限制使用者新增家事標籤時的字數
  
 ![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_02.gif)
 ![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/IMG_5489.png)
  
  
  
 
