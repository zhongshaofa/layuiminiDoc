# 使用说明（单页面 v1版本）

# 默认配置说明
 
* 默认配置在`layuimini.config`方法内，请自行修改
* urlHashLocation：是否开启URL地址hash定位，默认开启。`关闭后，刷新页面后将定位不到当前页，只显示主页`
* urlSuffixDefault：是否开启URL后缀，默认开启。
* BgColorDefault：系统默认皮肤，从0开始。

> 示例说明

```js
       var config = {
             urlHashLocation: true,   // URL地址hash定位
             urlSuffixDefault: true, // URL后缀
             BgColorDefault: 0       // 默认皮肤（0开始）
          };
```

# 后台模板初始化

 * 在`index.html`文件内进行初始化

 * 引入`lay-config.js`文件，请根据实际情况修改里面扩展的路径。

 * `layuimini.init();` 方法内的参数请填写动态api地址。（实际应用中，请以`后端API接口`方式去实现）

 * 初始化api地址返回的参数可以参考`api目录下的init.json文件`或者查看使用说明的第二点的参数说明

> 示例说明

```js
    layui.use(['element', 'layer', 'layuimini'], function () {
        var $ = layui.jquery,
            element = layui.element,
            layer = layui.layer;

        layuimini.init('api/init.json');
    });
    
```
 
# 初始化api地址返回的参数说明
 
 * `clearInfo`是服务端清理缓存信息(clearInfo.clearUrl：服务端清理缓存接口地址，为空则不请求;)
 
> 示例说明

```json
  返回参数对应的事例(code：0，清除缓存失败；code：1，表示清除缓存成功；)
  
  {
    "code": 1,
    "msg": "清除服务端缓存成功"
  }
```
 
 * `homeInfo` 是首页信息
 
 * `logoInfo` 是logo信息
 
 * `menuInfo` 是头部模块和左侧菜单对应的信息
 
 * `menuModule id`必须唯一，例如 menuInfo.currency、menuInfo.other对应的currency和other就是模块id，他们的值必须唯一，否则模块切换会有冲突。
 
> 示例说明

```json
{
  "homeInfo": {
    "title": "首页",
    "icon": "fa fa-home",
    "href": "page/welcome-2.html?mpi=m-p-i-0"
  },
  "logoInfo": {
    "title": "LayuiMini",
    "image": "images/logo.png",
    "href": ""
  },
  "clearInfo": {
    "clearUrl": "api/clear.json"
  },
  "menuInfo": {
      "currency": {
        "title": "常规管理",
        "icon": "fa fa-address-book",
        "child": [
            .......
        ],
      "other": {
        "title": "其它管理",
        "icon": "fa fa-slideshare",
        "child": [
            .......
        ]
    }
  }
}
```
  
# 在页面中打开新页面
   
  * 如需在页面中弹出新的Tab窗口，请参考下方代码。
  * 参数说明（data-iframe-tab：页面链接，data-title：标题，data-icon：图标）
  
> 示例说明

```html
    <a href="javascript:;" data-content-href="page/user-setting.html" data-title="基本资料">基本资料</a>
 ```

# 在js中跳转页面

  * 如需在js跳转页面，请参考下方代码。（备注：需要引入layuimini.js文件）
  * 调用方法：`layuimini.hash(href);`
  * 示例在`user-setting.html`页面中
  
> 示例说明

```js
    layui.use(['form','layuimini'], function () {
        var form = layui.form,
            layer = layui.layer,
            layuimini = layui.layuimini;

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
                layuimini.hash('page/welcome-1.html');
            });
            return false;
        });

    });
```

# 在js中局部刷新页面

  * 如需在js局部刷新页面，请参考下方代码。（备注：需要引入layuimini.js文件）
  * 调用方法：`layuimini.refresh();`
  * 示例在`user-password.html`页面中
  
> 示例说明

```js
    layui.use(['form','layuimini'], function () {
        var form = layui.form,
            layer = layui.layer,
            layuimini = layui.layuimini;

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
                layuimini.refresh();
            });
            return false;
        });

    });
```
  
# 后台主题方案配色
  
 * 系统已内置12套主题配色，如果需要自定义皮肤配色，请在`layuimini.bgColorConfig`方法内按相同格式添加。
 
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
        },
        {
            headerRight: '#23262e',
            headerRightThis: '#0c0c0c',
            headerLogo: '#0c0c0c',
            menuLeft: '#23262e',
            menuLeftThis: '#1aa094',
            menuLeftHover: '#3b3f4b',
        }
    ];
```
 
# 常见问题
  * IIS环境下请配置支持解析`.json`格式文件
  * <font color=red>修改js后刷新页面未生效，请尝试清除浏览器缓存。</font>
  * form表单刷新，部分组件不显示的情况，请在js上加上`form.render();`
  
# 备注信息
  * 菜单栏建议最多四级菜单，四级以后菜单显示并没有那么友好。