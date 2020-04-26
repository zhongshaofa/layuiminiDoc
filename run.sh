grep -rl 'src="../gitbook'  _book | xargs sed -i 's/src="..\/gitbook/src="https:\/\/layuimini.oss-cn-shenzhen.aliyuncs.com\/public\/uploads\/gitbook/g'
grep -rl 'href="../gitbook' _book | xargs sed -i 's/href="..\/gitbook/href="https:\/\/layuimini.oss-cn-shenzhen.aliyuncs.com\/public\/uploads\/gitbook/g'
grep -rl 'src="gitbook' _book | xargs sed -i 's/src="gitbook/src="https:\/\/layuimini.oss-cn-shenzhen.aliyuncs.com\/public\/uploads\/gitbook/g'
grep -rl 'href="gitbook' _book | xargs sed -i 's/href="gitbook/href="https:\/\/layuimini.oss-cn-shenzhen.aliyuncs.com\/public\/uploads\/gitbook/g'