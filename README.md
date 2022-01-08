# DarkNetonOpenSUSE
在OpenSUSE上配置nvidia-docker 并运行darknet的保姆级别教程
### 安装NVIDIA驱动
直接通过zypper就可以安装了
* 先添加nvida驱动源
```shell
sudo zypper addrepo --refresh 'https://download.nvidia.com/opensuse/leap/$releasever/' NVIDIA
sudo zypper refresh
```
* 然后查看下自己在用啥显卡
```shell
sudo lspci | grep VGA
```
查看下有哪些驱动可以选择
```shell
sudo zypper se -s x11-video-nvidiaG0*
S | Name                | Type    | Version     | Arch   | Repository
--+---------------------+---------+-------------+--------+-----------
  | x11-video-nvidiaG04 | package | 390.116-5.1 | x86_64 | NVIDIA    
  | x11-video-nvidiaG04 | package | 390.116-5.1 | i586   | NVIDIA    
  | x11-video-nvidiaG05 | package | 470.56-9.1  | x86_64 | NVIDIA
 ```
 到英伟达官网找到可以支持的驱动 只要不是远古卡 470都可以用
 * 安装驱动
 ```
 sudo zypper in <x11-video-nvidiaG04 或者 x11-video-nvidiaG05>
 ```
 * 重新启动
 ### 安装docker和nvidia-docker
 * 通过zypper安装docker
 ```
 sudo zypper install docker python3-docker-compose
 sudo usermod -G docker -a $USER
 ```
 启动docker
 ```
 sudo systemctl --now enable docker
 ```
 * 添加nvdia-docker 源 并安装nvidia-docker
 ```
 sudo zypper ar https://nvidia.github.io/nvidia-docker/opensuse-leap15.1/nvidia-docker.repo
 sudo zypper ref
 ```
 * 安装nvidia docker
 ```
 sudo zypper install -y nvidia-container-toolkit
 ```
 * 测试一发
 ```
 $ sudo docker run --gpus all nvidia/cuda:10.0-base nvidia-smi

# 类似以下显示就是成功了
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.57.02    Driver Version: 470.57.02    CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  Off  | 00000000:01:00.0  On |                  N/A |
| 35%   45C    P0    44W / 260W |    732MiB / 11016MiB |      2%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+
```
### 安装darknet
 先git clone 本项目，然后cd 到这个项目的目录

 编辑FROM 冒号后面的cuda+cudnn版本，由于需要源码编译安装（理论上可以直接给darknet的二进制+runtime镜像，但这样子就不清真了）所以需要选择dev镜像，镜像版本在[这里](https://gitlab.com/nvidia/container-images/cuda/-/blob/master/doc/supported-tags.md)找

 运行`sudo docker build -t <起个名字> .`
 
 试试看`sudo docker run --gpus all  <刚才的名字> darknet` 显示 `usage: darknet <function>`说明程序正常起来了，接着就是挂载volume开始训练
