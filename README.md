# C++ Move Semantics（中文翻译版 · LaTeX 工程）

把 Nicolai M. Josuttis 的 *C++ Move Semantics: The Complete Guide*（2020）译为中文，
并用 Manning 风格小开本版式（531.36bp × 628.83bp）重排为可编译的 LaTeX 工程。

- 原书：*C++ Move Semantics — The Complete Guide*
- 作者：Nicolai M. Josuttis
- 译者：[陈晓伟](https://github.com/xiaoweiChen)
- 首次出版：2020 年 10 月 27 日
- 中文名：**C++ Move Semantics 中文版**

---

## 目录结构

```
CPP-Move-Semantics/                # 本目录即工程根
├── main.tex                       # 编译入口：\input{book/ccs.tex} + \subfile{book/index.tex}
├── build.bat / build.sh           # 一键编译：三遍 xelatex，成功后清理 *.minted 缓存
├── main.pdf                       # 编译成品（252 页）
├── images/                        # 插图：按章分子目录 images/chapterN/ + cover.png
├── tools/
│   └── convert.py                 # 片段 → 一章一文件 的转换器（同时生成 book/index.tex）
├── book/
│   ├── ccs.tex                    # 导言区：字体/版式/自定义命令与环境、minted v3 缓存配置
│   ├── index.tex                  # 封面、目录、部/章装配（由 tools/convert.py 生成，勿手改）
│   ├── manning-pygments-style.tex # 代码高亮配色（原书配色）
│   └── content/
│       ├── front/                 # 00-cover(封面图) / 00-title(扉页) / 01-preface / 02-about / 03-blurb
│       ├── part/                  # 三部分部引言（part1–part3）
│       └── main/                  # 第 1–15 章：01.tex … 15.tex（一章一文件）
├── content/                       # 【原始片段式译稿】content/1/chapter1/1.tex 之类，仅作转换输入
├── C++-Move-Semantics.tex         # 【原主文件】部/章/节结构与标题的来源
├── cover.png                      # 原封面（转换时复制到 images/cover.png）
└── fonts/                         # 备选等宽字体（JetBrains Mono NL，当前版式未启用）
```

> 正文源文件必须放 `book/content/` 下：`\subfile` 的相对基准是 `book/`，图片路径仍写
> `images/...`（相对工程根，`\graphicspath{{images/}{./}}`）。
> `content/`、`C++-Move-Semantics.tex`、`cover.png` 是原始素材，只被 `tools/convert.py` 读取，
> 不参与编译。

---

## 环境依赖

| 依赖 | 版本 / 说明 |
|---|---|
| TeX Live | 2026（含 `xelatex`、minted **v3** / `latexminted`、`tcolorbox`、`tikz`、`tabularx`、`booktabs`、`multicol`） |
| Python | 3.x + **Pygments**（minted v3 由 `latexminted` 调它做高亮）；本机 `D:\anaconda3` |
| 中文字体 | **思源宋体 Source Han Serif SC**（正文）、**Microsoft YaHei**（中文标题、代码内中文注释） |
| 拉丁字体 | Cambria（正文）、Franklin Gothic Medium（标题） |
| 等宽字体 | Consolas（`book/ccs.tex` 里写死 `C:/Windows/Fonts/consola*.ttf`） |

> 字体缺失会直接报 "font not found"。思源宋体需本机已安装，微软雅黑为 Windows 自带。

---

## 编译

```bat
build.bat          :: 三遍 xelatex，成功后删除 *.minted 缓存
```

```bash
bash build.sh      # 同上（Git Bash / MSYS 环境；本机需用 /usr/bin/bash build.sh）
```

手动编译时**必须**把 minted 缓存目录指成绝对路径（见「已知坑」第 2 条）：

```bash
# Python 根目录要在 TeX bin 之前：latexminted 是 Python 脚本，需能 import pygments
export PATH="/d/anaconda3:/d/ProgramData/texlive/2026/bin/windows:$PATH"
export TEXMF_OUTPUT_DIRECTORY="D:/Ego/trans/CPP-Move-Semantics"
export TEXMFOUTPUT="$TEXMF_OUTPUT_DIRECTORY"

xelatex -shell-escape -interaction=nonstopmode -synctex=1 main.tex   # 跑三遍
```

- `-shell-escape` 是必须的（minted 调外部高亮器）。
- **必须三遍**：目录、书签、交叉引用要收敛；封面用 `remember picture` 定位，两遍才到位。
- 首次编译较慢（minted 逐个高亮 447 个代码块），改稿期可反复跑第二、三遍。
- 排错时给 `xelatex` 加 `-file-line-error`，可直接定位到文件与行号。
- 产物：`main.pdf`（252 页）、`main.aux`、`main.toc`、`main.log`、`main.synctex.gz`。

---

> 如果环境配置遇到问题或者编译失败，可直接到[ releases](https://github.com/jnulzl/CPP-Move-Semantics-CN/releases)下载最新的 pdf 文件。

---

## 本书相关

- 译者 GitHub（中文译稿）：<https://github.com/xiaoweiChen/CPP-Move-Semantics>
- 作者主页：<http://www.josuttis.com>

---

## 本书概述

完整的介绍 C++ Move 语义。

C++11 添加的 Move 语义已经成为现代 C++ 的标志，也使语言变得复杂，即使经验丰富的开发者
仍在需要仔细处理 Move 语义的细节。因为这个原因，一些编程书籍甚至不推荐对非常简单的类
使用 Move 语义。所以，详细的解释 C++ Move 语义就变得刻不容缓。

本书会从基本原理开始来介绍 Move 语义，并会解释 Move 语义的所有细节，使每个开发者都可以
正确地使用 Move 语义。

你将学习到：

* Move 语义的起因和术语

* 如何隐式地获益于 Move 语义

* 如何明确地获益于 Move 语义

* 会遇到的所有问题，以及如何处理它们

* 所有的结果都取决于你的编程风格

重点在于所描述的特性，需要在实践中进行应用。示例和背景信息，有助于理解和改进简单类，
甚至泛型库和框架的代码。

> “我以为我理解了 Move 的语义，但我真的不懂！我从你的书中学到了很多东西。” —— Jonathan Boccara
>
> “这是我需要很久的书。” —— Rob Bernstein
>
> “有时候我觉得我对纠缠和量子隐形传态的理解，要比我对一些奇怪的 C++ Move 语义的理解要好。
> 套用 Feynman 的话：如果你认为你理解了 C++ 的 Move 语义，那你就不理解 C++ 的 Move 语义。
> 赶快阅读这本书吧。” —— Victor Ciura

## 作者简介

Nicolai Josuttis（<http://www.josuttis.com>）在编程界很有名，因为他的发言和著作都很有权威，
还是世界范围内畅销书的（共同）作者：

* 《The C++ Standard Library》

* 《C++ Templates》

* 《C++ Move Semantics》

* 《C++17》

* 《SOA in Practice》

同时也是一位富有创新精神的演讲者，曾在各种会议和活动中发言。还是独立的讲师，
并且在 C++ 标准化方面有 20 多年的经验。
