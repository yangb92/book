# 芯片

##  74HC595 芯片

74HC595 是一个 8 位串行输入、并行输出的位移缓存器，其中并行输出为三态输出（即高电平、低电平和高阻抗）

串行写入代码:

```c
#include<reg52.h>
#include<intrins.h>

typedef unsigned int u16;
typedef unsigned char u8;

sbit SRCLK = P3^6;
sbit RCLK = P3^5;
sbit SER = p3^4;
/**
	发送8位数据
*/
void Hc595SendByte(u8 dat){
    u8 i;
    SRCLK = 1;
    RCLK = 1;
    for(i=0;i<8;i++){
        SER = dat >> 7;
        dat <<= 1;
        SRCLK = 0;
        _nop_();
        _nop_();
        SRCLK = 1;
    }
    RCLK = 0; 
    _nop_(); 
    _nop_(); 
    RCLK = 1;
}
```

