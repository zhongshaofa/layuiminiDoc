# java动态生成初始化数据（spring框架）

##### 示例提供来源：香喷喷的如歌

> 对应控制器 `controllers/IndexController.java`

``` 

@RestController
@RequestMapping("login")
public class LoginController {
    @Resource
    private SysMenuService sysMenuService;

    @GetMapping("/menu")
    public Map<String, Object> menu() {
        return sysMenuService.menu();
    }
}
```
 

> 对应Service逻辑层  `service/SysLoginServiceImpl.java`

``` 
@Service
public class SysMenuServiceImpl implements SysMenuService {
    @Resource
    private SysMenuRepository sysMenuRepository;
    @Override
    public Map<String, Object> menu() {
        Map<String, Object> map = new HashMap<>(16);
        Map<String,Object> home = new HashMap<>(16);
        Map<String,Object> logo = new HashMap<>(16);
        List<SysMenu> menuList = sysMenuRepository.findAllByStatusOrderBySort(true);
        List<MenuVo> menuInfo = new ArrayList<>();
        for (SysMenu e : menuList) {
            MenuVo menuVO = new MenuVo();
            menuVO.setId(e.getKey().getId());
            menuVO.setPid(e.getPid());
            menuVO.setHref(e.getKey().getHref());
            menuVO.setTitle(e.getKey().getTitle());
            menuVO.setIcon(e.getIcon());
            menuVO.setTarget(e.getTarget());
            menuInfo.add(menuVO);
        }
        map.put("menuInfo", TreeUtil.toTree(menuInfo, 0L));
       home.put("title","首页");
        home.put("href","/page/welcome-1");//控制器路由,自行定义
        logo.put("title","后台管理系统");
        logo.put("image","/static/images/back.jpg");//静态资源文件路径,可使用默认的logo.png 
        map.put("homeInfo", "{title: '首页',href: '/ruge-web-admin/page/welcome.html'}}");
        map.put("logoInfo", "{title: 'RUGE ADMIN',image: 'images/logo.png'}");
        return map;
    }
}

``` 

> TreeUtil` util/TreeUtil.java`

```
public class TreeUtil {

    public static List<MenuVo> toTree(List<MenuVo> treeList, Long pid) {
        List<MenuVo> retList = new ArrayList<MenuVo>();
        for (MenuVo parent : treeList) {
            if (pid.equals(parent.getPid())) {
                retList.add(findChildren(parent, treeList));
            }
        }
        return retList;
    }
    private static MenuVo findChildren(MenuVo parent, List<MenuVo> treeList) {
        for (MenuVo child : treeList) {
            if (parent.getId().equals(child.getPid())) {
                if (parent.getChild() == null) {
                    parent.setChild(new ArrayList<>());
                }
                parent.getChild().add(findChildren(child, treeList));
            }
        }
        return parent;
    }
}

```

> repository层 `reposiroty/SysMenuRepository.java`

```
public interface SysMenuRepository extends JpaRepository<SysMenu, Long> {
    
    //这里我只查询页面转态为启用,可自行定义和写
    @Query(value = "select * from  permission_security.system_menu where STATUS = 1  ORDER BY  sort ",nativeQuery = true)
    public List<SystemMenu> getSystemMenuByStatusAndSort(Long status,Integer sort);
   
    List<SysMenu> findAllByStatusOrderBySort(Boolean status);
}
```

> entity层 `entity/MenuEntity.java`

```
@Getter
@Setter
@Embeddable
public class MenuKey implements Serializable {
    private Long id;
    private String title;
    private String href;
}



@Getter
@Setter
@Entity
@Table(name = "system_menu")
public class SysMenu implements Serializable {
  // 复合主键要用这个注解
    @EmbeddedId
    private MenuKey key;
    private Long pid;
    private String icon;
    private String target;
    private Integer sort;
    private Boolean status;
    private String remark;
     @CreatedDate
    private Date create_at;
     @CreatedDate
    private Date update_at;
    private Date delete_at;
}


@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class MenuVo {
    private Long id;

    private Long pid;

    private String title;

    private String icon;

    private String href;

    private String target;

    private List<MenuVo> child;
}

//这里是常规写法不使用lombok

/**
 *  insert和update注解,解决新增和更新的时候没有使用默认值
 * @Author wupeng 
 * @Date 2020-04-25
 * @Description   name ="表" 删掉permission_security. schema=""可删掉不必跟我，前提是你的表对应你的表空间就是数据库
 */

@Entity
@Table ( name ="permission_security.system_menu" , schema = "root")
@DynamicInsert
@DynamicUpdate
public class SystemMenu  implements Serializable {

	private static final long serialVersionUID =  5421757630121636006L;

	/**复合主键要用这个注解*/
	@EmbeddedId
	private MenuKey key;


	/**
	 * 父ID
	 */
   	@Column(name = "pid" )
	private Long pid;



	/**
	 * 菜单图标
	 */
   	@Column(name = "icon")
	private String icon;

	/**
	 * 链接打开方式
	 */
   	@Column(name = "target",columnDefinition = "_self")
	private String target;
	/**
	 * 菜单排序
	 */
   	@Column(name = "sort" )
	private Long sort;

	/**
	 * 状态(0:禁用,1:启用)
	 */
   	@Column(name = "status",columnDefinition = "tinyint DEFAULT 1")
	private Integer status;

	/**
	 * 备注信息
	 */
   	@Column(name = "remark" )
	private String remark;

	/**
	 * 创建时间
	 */
   	@Column(name = "create_at" )
	private Date createAt;

	/**
	 * 更新时间
	 */
   	@Column(name = "update_at" )
	private Date updateAt;

	/**
	 * 删除时间
	 */
   	@Column(name = "delete_at" )
	private Date deleteAt;

/*	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}*/

	public Long getPid() {
		return this.pid;
	}

	public void setPid(Long pid) {
		this.pid = pid;
	}



	public String getIcon() {
		return this.icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}



	public String getTarget() {
		return this.target;
	}

	public void setTarget(String target) {
		this.target = target;
	}

	public Long getSort() {
		return this.sort;
	}

	public void setSort(Long sort) {
		this.sort = sort;
	}

	public Integer getStatus() {
		return this.status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Date getCreateAt() {
		return this.createAt;
	}

	public void setCreateAt(Date createAt) {
		this.createAt = createAt;
	}

	public Date getUpdateAt() {
		return this.updateAt;
	}

	public void setUpdateAt(Date updateAt) {
		this.updateAt = updateAt;
	}

	public Date getDeleteAt() {
		return this.deleteAt;
	}

	public void setDeleteAt(Date deleteAt) {
		this.deleteAt = deleteAt;
	}

	public MenuKey getKey() {
		return key;
	}

	public void setKey(MenuKey key) {
		this.key = key;
	}

}


@Embeddable
public class MenuKey implements Serializable {


    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    /**
     * 名称
     */
    @Column(name = "title")
    private String title;
    /**
     * 链接
     */
    @Column(name = "href")
    private String href;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }
}

@JsonInclude(JsonInclude.Include.NON_NULL)
public class MenuVo {

    private Long id;

    private Long pid;

    private String title;

    private String icon;

    private String href;

    private String target;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getPid() {
        return pid;
    }

    public void setPid(Long pid) {
        this.pid = pid;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    public List<MenuVo> getChild() {
        return child;
    }

    public void setChild(List<MenuVo> child) {
        this.child = child;
    }

    private List<MenuVo> child;
}


```
> yml配置文件 `resource/application.yml`

```
#本地开发环境配置中心

spring:
  application:
    name: springboot-webAdmin
  jpa:
    show-sql: true
    database: mysql
    #generate-ddl: true
    database-platform: org.hibernate.dialect.MySQL5Dialect
    hibernate:
      naming:
          #解决使用其他库的表时候，把小数点变成下划线，导致sql无法成功执行。
          #这是由于物理命名策略引起的，大写字母变小写，加_下划线（hibernate5以上高版本）
       physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
      #ddl-auto: update
    #ddl-auto: update
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/数据库名称?characterEncoding=utf-8&serverTimezone=GMT%2B8
    username: root
    password: 123456
    driver-class-name: com.mysql.jdbc.Driver
    type: com.zaxxer.hikari.HikariDataSource
    hikari:
      auto-commit: true
      minimum-idle: 2
      idle-timeout: 60000
      connection-timeout: 30000
      max-lifetime: 1800000
      pool-name: DatebookHikariCP
  #thymeleaf模板配置
  thymeleaf:
    cache: false
    enabled: true
    prefix: classpath:/templates/
    suffix: .html
    #严格执行H5标准
    mode: LEGACYHTML5
    encoding: UTF-8
    servlet:
      content-type: text/html
  #content-type: text/html
  resources:
    chain:
      strategy:
        content:
          enabled: true
          paths: /**

  #静态资源路径
  mvc:
    static-path-pattern: /static/**
    #关掉原生icon图标
    favicon:
      enabled: false

#项目端口
server:
  port: 8080
  #连接超时，单位为毫秒，-1永不超时
  connection-timeout: 60000
  #设置tomcat参数
  tomcat:
    uri-encoding: utf-8
    max-connections: 10000
    min-spare-threads: 10
    #最大220个并发，可以达到不丢包（可以自己实测），默认为200。
    max-threads: 220
  #配置访问路径，默认为/
  #servlet:
    #context-path: /index/main



#配置日志文件参数
logging:
  file:
    path: F:/myLog/adminLog.log
  level:
    org:
      springframework: debug
    hibernate: debug

```