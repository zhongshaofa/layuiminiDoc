# 使用说明（单页面 v2版本）

# 更新说明
> V2版本相比于V1，核心代码进行重构，更加更加规范，配置使用起来也更方便。

* js模块的拆分，代码更加规范化。
* 配置项移出到外部的初始化配置里面。
* 单页封装进行重构，视觉和操作体验上更加良好。
* 新增菜单在初始化的时候可以展开子菜单。
* 新增初始化时一个配置项完成`多模块`和`单模块`之间的切换，接口的初始化数据还是一样的。
* 优化手机端初始化时的自适应，不会出现闪动的问题。
* 重构手机端左侧菜单，弹出菜单时不会挤压内容内面。
* 优化初始化时的接口返回的数据格式`api/init.json`，以适配单模块的切换。
* 新增初始化加载层，更好的视觉体验
* 新增初始化页面是否加版本号
* 优化返回主页按钮以及页面导航栏的实现
* 优化主题配色方案



# 基础参数一览表

> 以下参数是`miniAdmin.render();`初始化时进行传入。

| 参数 | 说明 |类型 | 默认值| 备注 |
| --- | --- |--- |--- |--- |
| iniUrl | 初始化接口 | string | null | 实际使用，请对接后端接口动态生成，格式请参考文件：`api/init.json` |
| clearUrl | 缓存清理接口 | string | null | 实际使用，请对接后端接口动态生成，格式请参考文件：`api/init.json` |
| renderPageVersion | 初始化页面是否加版本号 | bool | false | 开启后，页面不会有缓存问题|
| bgColorDefault | 主题默认配置 | int | 0 | 如需添加更多主题信息，请在`js/lay-module/layuimini/miniTheme.js`文件内添加|
| multiModule | 是否开启多模块 | bool | false | 个人建议开启 |
| menuChildOpen | 是否默认展开菜单 | bool | false | 个人建议关闭 |
| loadingTime| 初始化加载时间 | 0 | 0 | 建议0-2之间 |

> 示例说明

```js
        var options = {
            iniUrl: "api/init.json",    // 初始化接口
            clearUrl: "api/clear.json", // 缓存清理接口
            urlHashLocation: true,      // 是否打开hash定位
            bgColorDefault: 0,          // 主题默认配置
            multiModule: true,          // 是否开启多模块
            menuChildOpen: false,       // 是否默认展开菜单
            loadingTime: 0,             // 初始化加载时间
        };
        miniAdmin.render(options);  
```

# 后台模板初始化

 * 在`index.html`文件内进行初始化

 * 引入`lay-config.js`文件，请根据实际情况修改里面扩展的路径。

 * 引入miniAdmin模块，根据需要传入初始化参数，执行`miniAdmin.render(options);` 方法。

 * 初始化api接口返回的参数可以参考`api目录下的init.json文件`或者查看使用说明的第二点的参数说明

> 示例说明

```js
    layui.use(['jquery', 'layer', 'miniAdmin'], function () {
        var $ = layui.jquery,
            layer = layui.layer,
            miniAdmin = layui.miniAdmin;

        var options = {
            iniUrl: "api/init.json",    // 初始化接口
            clearUrl: "api/clear.json", // 缓存清理接口
            urlHashLocation: true,      // 是否打开hash定位
            bgColorDefault: 0,          // 主题默认配置
            multiModule: true,          // 是否开启多模块
            menuChildOpen: false,       // 是否默认展开菜单
        };
        miniAdmin.render(options);
        
    });
    
```
 
# 初始化api接口返回的参数说明
 
 * `homeInfo` 是首页信息
 
 * `logoInfo` 是logo信息
 
 * `menuInfo` 是头部模块和左侧菜单对应的信息
 
> 示例说明

```json
{
  "homeInfo": {
    "title": "首页",
    "href": "page/welcome-1.html?t=1"
  },
  "logoInfo": {
    "title": "LAYUI MINI",
    "image": "images/logo.png",
    "href": ""
  },
  "menuInfo": [
    {
      "title": "常规管理",
      "icon": "fa fa-address-book",
      "href": "",
      "target": "_self",
      "child":[...]
    },
    {
      "title": "组件管理",
      "icon": "fa fa-lemon-o",
      "href": "",
      "target": "_self",
      "child":[...]
    },
    {
      "title": "其它管理",
      "icon": "fa fa-slideshare",
      "href": "",
      "target": "_self",
      "child":[...]
    }
  ]
}
```
  
# 缓存清理接口返回的参数说明
 
 >   返回参数对应的事例(code：0，清除缓存失败；code：1，表示清除缓存成功；)
 
```json
   {
     "code": 1,
     "msg": "清除服务端缓存成功"
   }
```
  
# 在页面中打开新的页面
   
  * 在页面中打开新的页面，请参考下方代码。（备注：需要引入miniPage.js文件）
  * 参数说明（layuimini-content-href=：页面链接，data-title：标题）
  * 调用方法进行监听：`miniPage.listen();`(备注：框架初始化时已经进行监听，一般情况下不需要再次操作)
  * 示例在`page/welcome-1.html`页面中有

```html
     
    <a href="javascript:;" layuimini-content-href="page/user-setting.html" data-title="基本资料" >基本资料</a>
    
```

# 在内容页面中返回主页
   
  * 方法一：添加class样式layuimini-back-home`<a lay-href="" href="javascript:;" class="layuimini-back-home">首页</a>`
  * 方法二：`miniPage.hashHome();`，示例在`user-password.html`,`user-setting.html`页面中都有
  
> 示例说明

```js
    layui.use(['form','miniPage'], function () {
        var form = layui.form,
            layer = layui.layer,
            miniPage = layui.miniPage;

        /**
         * 初始化表单，要加上，不然刷新部分组件可能会不加载
         */
        form.render();

        //监听提交
        form.on('submit(saveBtn)', function (data) {
            var index = layer.alert(JSON.stringify(data.field), {
                title: '最终的提交信息'
            }, function () {
                layer.close(index);
                miniPage.hashHome();
            });
            return false;
        });

    });
```
  
# 后台主题方案配色
  
 * 系统已内置12套主题配色，如果需要自定义皮肤配色，请在`miniTheme.bgColorConfig`方法内按相同格式添加。
 
> 示例说明

```js
    var bgColorConfig = [
                {
                    headerRight: '#1aa094',
                    headerRightThis: '#197971',
                    headerLogo: '#243346',
                    menuLeft: '#2f4056',
                    menuLeftThis: '#1aa094',
                    menuLeftHover: '#3b3f4b',
                    tabActive: '#1aa094',
                },
                {
                    headerRight: '#23262e',
                    headerRightThis: '#0c0c0c',
                    headerLogo: '#0c0c0c',
                    menuLeft: '#23262e',
                    menuLeftThis: '#737373',
                    menuLeftHover: '#3b3f4b',
                    tabActive: '#23262e',
                }
    ];
```
 
# 常见问题
  * <font color=red>修改js后刷新页面未生效，请尝试清除浏览器缓存。</font>
  * IIS环境下请配置支持解析`.json`格式文件
  
# 备注信息
  * 菜单栏建议最多四级菜单，四级以后菜单显示并没有那么友好。