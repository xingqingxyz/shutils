# git-delta_0.16.5_amd64.deb
select(.name | test("git-delta_[\\d.]+_amd64.deb")) | .downloadUrl
# fzf-0.44.1-linux_amd64.tar.gz
select(.name | test("fzf-[\\d.]+-linux_amd64.tar.gz")) | .downloadUrl
# fzy-1.0.tar.gz
select(.name | test("fzy-[\\d.]+.tar.gz")) | .downloadUrl
# ripgrep_14.0.3-1_amd64.deb
select(.name | test("ripgrep_[\\d.-]+_amd64.deb")) | .downloadUrl
# sd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz
select(.name | test("sd-v[\\d.]+-x86_64-unknown-linux-gnu.tar.gz")) | .downloadUrl
# lua-language-server-3.7.4-linux-x64.tar.gz
select(.name | test("lua-language-server-[\\d.]+-linux-x64.tar.gz")) | .downloadUrl
