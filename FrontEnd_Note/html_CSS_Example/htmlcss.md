# HTML and CSS example and project

## display example: 導彈頁面 Navigator Menu
Understand display:
- Inline: 只有左右可以動，上下不會有反應  
- block：預設會換行 default will break
- inline-block:
- Example:
  - HTML
  ```HTML=
  <ul>
    <li class ="" >課程介紹 </li>
   <li class ="">預計單元 </li>
   <li class ="" >常見問題 </li>
   <li class ="">留言發問 </li>
  </ul>
  ```
  - CSS
    ```CSS=
    li {
      display: inline-block;

      letter-spacing: 2px;
      padding: 5px;
      padding-left: 20px;
      padding-right: 20px;
      background-color: green;
      border-bottom: solid 7px black;
      color: white;    
    }
    ```
    
