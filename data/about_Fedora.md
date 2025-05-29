## [auto update](https://docs.fedoraproject.org/zh_CN/quick-docs/securing-the-system-by-keeping-it-up-to-date/#_setting_automatic_updates)

```sh
sudo dnf install -y dnf-automatic
sudo systemctl enable --now dnf-automatic.timer
sudo systemctl status dnf-automatic.timer
```
