---
title: "读'Detecting Text in Natural Image with Connectionist Text Proposal Network'"
author: 林以明
date: "2018-08-03 10:01"
comments: true
category: paper
---

## 目标
解决对象识别算法无法精准识别文字行水平位置的问题。
## 思路
检测宽度固定（小尺度，16px）的小文本块，然后RNN连起来形成文本行。

## CTPN
![CTPN](../images/CTPN.png)
小文本快检测方法借鉴Fast-RCNN，用宽度固定、高度可变（K个尺度）的anchor。
```
The key insight is that a single window is able to predict objects in a wide range of scales and aspect ratios, by using a number of flexible anchors.
```

小文本块连成文本行利用双向LSTM

输出：score, 垂直位置和高度，水平位置

loss:
![loss](../images/loss.png)
![rc](../images/relative_coordinates.png)
<mark>*疑问：在计算预测box和真实box距离时，真实box采用跟预测box重叠最大的box，而非跟输入窗口重叠最大的box*</mark>
