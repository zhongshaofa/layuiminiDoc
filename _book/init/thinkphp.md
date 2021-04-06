# ThinkPHP框架示例(6.0版本)

> 为了方便演示，直接用Db类去写 `app/index/controller/Index.php`

```php
<?php

namespace app\index\controller;

use app\BaseController;
use think\facade\Db;

class Index extends BaseController{

    // 获取初始化数据
    public function getSystemInit(){
        $homeInfo = [
            'title' => '首页',
            'href'  => 'page/welcome-1.html?t=1',
        ];
        $logoInfo = [
            'title' => 'LAYUI MINI',
            'image' => 'images/logo.png',
        ];
        $menuInfo = $this->getMenuList();
        $systemInit = [
            'homeInfo' => $homeInfo,
            'logoInfo' => $logoInfo,
            'menuInfo' => $menuInfo,
        ];
        return json($systemInit);
    }

    // 获取菜单列表
    private function getMenuList(){
        $menuList = Db::name('system_menu')
            ->field('id,pid,title,icon,href,target')
            ->where('status', 1)
            ->order('sort', 'desc')
            ->select();
        $menuList = $this->buildMenuChild(0, $menuList);
        return $menuList;
    }

    //递归获取子菜单
    private function buildMenuChild($pid, $menuList){
        $treeList = [];
        foreach ($menuList as $v) {
            if ($pid == $v['pid']) {
                $node = $v;
                $child = $this->buildMenuChild($v['id'], $menuList);
                if (!empty($child)) {
                    $node['child'] = $child;
                }
                // todo 后续此处加上用户的权限判断
                $treeList[] = $node;
            }
        }
        return $treeList;
    }
}
```