## [auto update](https://docs.fedoraproject.org/zh_CN/quick-docs/securing-the-system-by-keeping-it-up-to-date/#_setting_automatic_updates)

```sh
sudo dnf install python3-dnf-plugin-rpmconf dnf-automatic -y
sudo rpmconf -a
sudo systemctl enable --now dnf-automatic-install.timer
sudo systemctl status dnf-automatic-install.timer
```
