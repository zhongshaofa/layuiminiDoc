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
```



