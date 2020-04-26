grep -rl '^src="../gitbook' ./ | xargs sed -i 's/src="../gitbook.*/src="layuimini.oss-cn-shenzhen.aliyuncs.com/public/uploads/gitbook/g'
grep -rl '^href="../gitbook' ./ | xargs sed -i 's/href="../gitbook.*/href="layuimini.oss-cn-shenzhen.aliyuncs.com/public/uploads/gitbook/g'
grep -rl '^src="gitbook' ./ | xargs sed -i 's/src="gitbook.*/src="layuimini.oss-cn-shenzhen.aliyuncs.com/public/uploads/gitbook/g'
grep -rl '^href="gitbook' ./ | xargs sed -i 's/href="gitbook.*/href="layuimini.oss-cn-shenzhen.aliyuncs.com/public/uploads/gitbook/g'