# ASP.NET CORE WebApi接口示例

##### 示例提供来源：A0~海阔天空 

> 创建ASP.NET CORE API项目数据库访问自行百度,数据库结构参考文档就行，结构都类似。

> 完整的后端示例地址：<https://github.com/chenyi2006520/SystemMenu>

>数据对象如下：

```C#
   /// <summary>
    /// 菜单表
    /// </summary>
    [Table("bee_system_menu")]
    public class SystemMenuEntity
    {
        /// <summary>
        /// ID
        /// </summary>
        [Key]
        [Required]
        public long id { get; set; }

        /// <summary>
        /// 父级ID
        /// </summary>
        [Required]
        public long pid { get; set; }
        /// <summary>
        /// 名称
        /// </summary>
        [Required]
        public string title { get; set; }

        /// <summary>
        /// 菜单图标
        /// </summary>
        public string icon { get; set; }

        /// <summary>
        /// 链接
        /// </summary>
        public string href { get; set; }

        /// <summary>
        /// 链接
        /// </summary>
        public string target { get; set; }
        /// <summary>
        /// 序号
        /// </summary>
        public int sort { get; set; }

        /// <summary>
        /// 是否菜单
        /// </summary>
        public bool status { get; set; }
    }
```

```C#
   /// <summary>
    /// 菜单结果对象
    /// </summary>
    public class MenusInfoResultDTO
    {
        /// <summary>
        /// 权限菜单树
        /// </summary>
        public List<SystemMenu> MenuInfo { get; set; }

        /// <summary>
        /// logo
        /// </summary>
        public LogoInfo LogoInfo { get; set; }

        /// <summary>
        /// Home
        /// </summary>
        public HomeInfo HomeInfo { get; set; }
    }

    public class LogoInfo
    {
        public string title { get; set; } = "sdsdsdsff";
        public string image { get; set; } = "images/logo.png";
        public string href { get; set; } = "";
    }

    public class HomeInfo
    {
        public string title { get; set; } = "首页";
        public string href { get; set; } = "page/welcome-1.html?t=1";

    }

    /// <summary>
    /// 树结构对象
    /// </summary>
    public class SystemMenu
    {
        /// <summary>
        /// 数据ID
        /// </summary>
        public long Id { get; set; }

         /// <summary>
        /// 父级ID
        /// </summary>
        public long PId { get; set; }

        /// <summary>
        /// 节点名称
        /// </summary>
        public string Title { get; set; }

        /// <summary>
        /// 节点地址
        /// </summary>
        public string Href { get; set; }

        /// <summary>
        /// 新开Tab方式
        /// </summary>
        public string Target { get; set; } = "_self";

        /// <summary>
        /// 菜单图标样式
        /// </summary>
        public string Icon { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        public int Sort { get; set; }

        /// <summary>
        /// 子集
        /// </summary>
        public List<SystemMenu> Child { get; set; }
    }
```

> 创建一个根对象来接受处理好的数据

```C#
    SystemMenu rootNode = new SystemMenu()
    {
        Id = 0,
        Icon = "",
        Href = "",
        Title = "根目录",
    };
```

> 递归处理数据库返回的数据方法参考如下，

```C#
    /// <summary>
    /// 递归处理数据
    /// </summary>
    /// <param name="systemMenuEntities"></param>
    /// <param name="rootNode"></param>
    public static void GetTreeNodeListByNoLockedDTOArray(SystemMenuEntity[] systemMenuEntities, SystemMenu rootNode)
    {
        if (systemMenuEntities == null || systemMenuEntities.Count() <= 0)
        {
            return;
        }

        var childreDataList = systemMenuEntities.Where(p => p.pid == rootNode.Id);
        if (childreDataList != null && childreDataList.Count() > 0)
        {
            rootNode.Child = new List<SystemMenu>();

            foreach (var item in childreDataList)
            {
                SystemMenu treeNode = new SystemMenu()
                {
                    Id = item.id,
                    Icon = item.icon,
                    Href = item.href,
                    Title = item.title,
                };
                rootNode.Child.Add(treeNode);
            }

            foreach (var item in rootNode.Child)
            {
                GetTreeNodeListByNoLockedDTOArray(systemMenuEntities, item);
            }
        }
    }
```

> 最后将rootNode的Child 赋值返回给 MenusInfoResultDTO.MenuInfo 返回给前端就行
