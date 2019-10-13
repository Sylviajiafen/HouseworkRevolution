# 翻轉家事

* App Store 連結： https://apps.apple.com/tw/app/id1481048778

一款紀錄家事項目與完成進度的 app，旨在讓家事變得更有趣，並促進全家人共同參與家庭事務
_____________________________________________________________________________________________________

**《登入 / 註冊》**

* 尊重使用者隱私，不需填入任何使用者資料，僅需設定一組密碼即可註冊

* 利用 `Regular Expression` 限制密碼欄位僅能填入大小寫英文字母及阿拉伯數字

* 利用 `UICollectionView` 製作預設家庭成員名稱，方便使用者加速註冊流程

* 登入時可利用 QRCode 掃描器，開啟相機掃描 QRCode，或是從相簿選擇 QRCode 檔案，讀取個人 id

* 隱私權政策頁面：使用 `WKWebView` 顯示 privacy term link 的內容

![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_00.gif)

_____________________________________________________________________________________________________
**《今日家事》**

* 顯示當日的家事項目：利用 weekday 搜尋當天的星期所設定之家事項目，
  在 database 中建立一筆當日日期的資料，並儲存家事項目的完成狀態
  
* 使用 `UICollectionView Drag and Drop API`，讓使用者可以藉由長按、拖曳，
  將家事項目移動至「完成了！」欄位
  
* 每完成一項家事，家人都會收到推播通知：實作 `Firebase Cloud Messaging`

* 使用 `UIViewPropertyAnimator` 完成神燈實現願望時的畫面淡入動畫，
  並讓動畫可藉由使用者點選 ```skip 按鈕``` 後提前結束。
  
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/IMG_5488.png)


![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/housework_01.gif)
![GITHUB](https://github.com/Sylviajiafen/HouseworkRevolution/blob/READMEresource/IMG_5506.png)
