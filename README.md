# Sram-controller-design-based-on-AHB-bus
## 基于 AHB 的 sram 设计框架图显示如下：

## hsize控制读写数据位宽与数据深度(默认位宽为32bit，深度为2^14)

![绘图5](https://user-images.githubusercontent.com/71707557/182754272-dd9540d8-3b8e-4967-a1ff-0342555d659a.png)

## 当hsize为2'b00时，数据位宽为8bit，数据深度为2^16

![fbc7243cd8f6d3286070628d774b1c8](https://user-images.githubusercontent.com/71707557/182756040-11988dca-7215-4767-9a53-8653e4ba6a65.png)

## 当hsize为2'b01时，数据位宽为16bit，数据深度为2^15

![979e27f5082deef4e8b00e63921ec6f](https://user-images.githubusercontent.com/71707557/182756083-7677d5d5-4924-4a9b-aad2-4096af8ff2ab.png)

## 当hsize为2'b10时，数据位宽为32bit，数据深度为2^14

![cdca3ff32af45260c13a686fb47f368](https://user-images.githubusercontent.com/71707557/182756109-daa0d467-e2a6-4313-9f7f-42238b6ffb14.png)
