## Hazel Engine

本仓库相关代码，仅供学习Hazel游戏引擎使用

### 相关依赖

#### 1. 日志 [spdlog](https://github.com/gabime/spdlog)

采用 `git-submodule` 管理，执行指令 `git submodule add git@git.zhlh6.cn:gabime/spdlog.git Hazel/vendor/spdlog` 可安装该依赖。确实卡，采用了加速源才下载成功。

#### 2. [Premake](https://github.com/premake/premake-core)

项目构建工具。其中 `GenerateProject.bat` 中的vs2022，需要适配成自己本地的工具集。




