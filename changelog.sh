#!/bin/bash

# 获取最新的 commit 信息
commit_hash=$(git log -1 --pretty=format:"%h")
commit_message=$(git log -1 --pretty=format:"%s")

dtag="$(git log -1 --format=%cd --date=format:'%Y%m%d%H%M%S')"

# 设置 package 名称、版本号、维护者信息等
package_name="mediawiki-page-publish"
version="$(< VERSION tr -d '\r\n\t ')"
maintainer="L. Jiang <l.jiang.1024@gmail.com>"

# 创建 changelog 内容
changelog="\
$package_name (${version}) unstable; urgency=low

  * $commit_message (commit $commit_hash)

 -- $maintainer  $(git log -1 --format=%cd --date=rfc)
"

# 输出到 debian/changelog 文件
echo "${changelog}" | tee debian/changelog