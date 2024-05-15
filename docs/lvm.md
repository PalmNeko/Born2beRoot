# lvm

## home を作る。

```sh
lvresize --size [任意のサイズ]M /dev/mapper/[home] --resizefs
```
などを使って、rootのサイズを縮小する。


## 作業ログ

* `sudo swapoff -v /dev/tookuyam42-vg/swap_1`
* `sudo lvreduce /dev/tookuyam42-vg/swap_1 --size -10M`
* `mkswap /dev/tookuyam42-vg/swap_1`
* `swapon -v /dev/tookuyam42-vg/swap_1`
* `cat /proc/swaps`

* `sudo lvcreate --size 8M -n home tookuyam42-vg`
* `sudo mkfs.ext4 /dev/tookuyam42-vg/home`
* `sudo vim.tiny /etc/fstab`
> append:
> `/dev/mapper/tookuyam42--vg-home	/home	ext4	defaults 0	0`
* test `sudo mount -a`
* `sudo mount /dev/mapper/tookuyam42--vg-home /home`
* `mkdir /home/tookuyam`

