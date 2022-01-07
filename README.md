#乱码问题已经修复，本地部署可以正常使用
## TODO：
>解决GitHubAction问题

# AutoFuck_yqfk
早睡计划，自动打卡
>Q：为什么要做这个？  
>A：仅仅是为了**堵漏**，怕就怕哪天早睡忘记打卡了。寒假这段时间里一旦断了，回学校就成大问题了。  
>Q：会继续更新吗？  
>A：下一步计划是做GPS定位，假如哪天整个打卡逻辑改了的话，能不能更取决于我有没有时间。  
>
>Q：为什么不用python，用powershell？  
>A： ~~写过了，用py就太简单了。~~ 
>  1. **powershell**是windows自带的平台，只要有windows就能使用ps，不用担心版本问题和环境问题，通用性和兼容性都很好 ~~（从开始到最后全部都用的字符串，连json都没用，不好才有鬼）~~ 。  
>  2. 发包可以从浏览器（我用的是edge）直接复制成powershell粘贴过来，不用自己构建数据包。  
#  部署方式
## 本地部署
说明： 部署在本地电脑上，电脑开启的时候，达到一定条件会触发脚本，适合每天都用电脑的hxd。
### 步骤：
#### 1.  用管理员模式打开powershell  
![image](https://user-images.githubusercontent.com/49357198/148472714-389e46bf-ab73-4916-9d51-f5d935e2c38c.png)
#### 2.  输入``` Set-ExecutionPolicy unrestricted ```，允许脚本执行  
![image](https://user-images.githubusercontent.com/49357198/148473011-dfd3908a-7f6e-4ecc-ae40-009269aec0e6.png)  
回车之后会出现一段提示，输入A，回车，选择全是即可  
![image](https://user-images.githubusercontent.com/49357198/148473210-f4720dd8-5174-4883-a286-b67c7c43b02a.png)
#### 3.  下载本项目到本地：  
  ![image](https://user-images.githubusercontent.com/49357198/148473355-300cb568-44c2-46c4-a9cc-44c5c07dc066.png)  
  得到的压缩包：
  ![image](https://user-images.githubusercontent.com/49357198/148473560-53ebdf94-f127-43e5-9c7a-d41577fd9112.png)  
  把压缩包内容解压到任意目录，得到：  
  ![image](https://user-images.githubusercontent.com/49357198/148473642-4cd07581-140b-411f-9a69-ee8e4ab4ee4b.png)  
#### 4.  修改bat脚本，改成自己的账号密码。  
  右键编辑：  
  ![image](https://user-images.githubusercontent.com/49357198/148473850-21c9943e-ab2f-4e3b-b691-f7a14b8acbdb.png)  
  把账号和密码写上去，替换掉中文 
  ![image](https://user-images.githubusercontent.com/49357198/148474031-dcd358c3-5655-405c-847e-2f21b5f6bc63.png)  
#### 4.1  测试（如果很相信这个脚本能够百分百运行，可以不进行测试）  
右键编辑 ``` AutoFuck_yqfk_V1.0.ps1 ```
![image](https://user-images.githubusercontent.com/49357198/148474210-59b8adf4-37da-4008-aa19-d742f2f3a630.png)  
你将会看到这样的界面：  
![image](https://user-images.githubusercontent.com/49357198/148474317-1013a388-5fba-420f-b139-c5cf28a0aaea.png)  
在以下位置加入以下代码：
```  
$username="你的中央认证账号"  
$psw="你的中央认证密码"  
```  
然后点击运行：  
![image](https://user-images.githubusercontent.com/49357198/148474551-1177ebdc-bd32-41c8-a5b9-d96f0ec918fa.png)
如果今天已经打卡，你将会看到如下结果：  
![image](https://user-images.githubusercontent.com/49357198/148474719-15124d0d-d580-4465-9e78-f40f1caec830.png)  
这个结果转换成中文字符：  
![image](https://user-images.githubusercontent.com/49357198/148474873-07abfee9-3a6b-4b5f-8e58-81724c529675.png)
如果从执行一开始，到出现这一行提示以外，都没有出现红色字符串，说明运行正常，否则登录没成功，可以把问题反馈给我 
测试通过之后，把刚刚加的内容删掉，保存
#### 5. 任务计划  
打开任务计划程序，找不到可以百度如何打开
![image](https://user-images.githubusercontent.com/49357198/148475200-c5952d90-ccd6-49a9-ab58-50738bcdf8e3.png)  
名称随便输入：  
![image](https://user-images.githubusercontent.com/49357198/148475324-08d5b3b1-e7fb-499c-96dc-9bb4c8791473.png)  
我的电脑一般晚上不关，所以触发器我选择的是每天，大家可以根据自己的习惯和需求修改  
![image](https://user-images.githubusercontent.com/49357198/148475407-ce7438ca-8ddf-4fd5-97f4-d18b13b09742.png)  
时间设置成十二点0：10分之后，否则容易失败  
![image](https://user-images.githubusercontent.com/49357198/148475571-c0f314a1-428e-47f7-a367-b75e08dbf802.png)  
操作选择执行程序：  
![image](https://user-images.githubusercontent.com/49357198/148475673-5329257e-df53-49c4-a697-96b925e6f6ba.png)  
找到刚才解压的程序目录，选择  ``` AutoFuck_yqfk_V1.0.cmd ``` 打开
![image](https://user-images.githubusercontent.com/49357198/148475802-065e5553-9f14-4937-9380-b1cb401a63e5.png)  
完成
![image](https://user-images.githubusercontent.com/49357198/148475895-438bc65f-f3d1-4b04-b7ff-b195d7157076.png)
## 注意：win11用户可能不适用此方法，因为win11用任务计划+命令行+powershell调用不成功，部署之后请观察一天是否能够打卡，确保能部署成功
