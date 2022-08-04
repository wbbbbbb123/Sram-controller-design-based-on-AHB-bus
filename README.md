基于 AHB 的 sram 设计框架图显示如下：
！[ahb_sramc_control] (https://user-images.githubusercontent.com/71707557/182021044-faa8c34b-b79c-4c70-94a8-ad29bf8b19d6.png)
hsize控制读写数据位宽与数据深度(默认位宽为32bit，深度为2**14)
![绘图5](https://user-images.githubusercontent.com/71707557/182754272-dd9540d8-3b8e-4967-a1ff-0342555d659a.png)
当hsize为2'b00时，数据位宽为8bit，数据深度为2**16
![绘图61](https://user-images.githubusercontent.com/71707557/182754440-1848af4a-c059-4a13-9610-762994b05800.png)
当hsize为2'b01时，数据位宽为16bit，数据深度为2**15
![绘图62](https://user-images.githubusercontent.com/71707557/182754522-a7cc7971-287a-4dc8-ab27-16fc448cc336.png)
当hsize为2'b10时，数据位宽为32bit，数据深度为2**14
![绘图63](https://user-images.githubusercontent.com/71707557/182754540-136877ca-abae-404c-b264-1adb24910833.png)
