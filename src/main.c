#include"code_def.h"

char Music_Code[]={ 0x16,0x03,0x21,0x03,0x23,0x03,0x26,0x03,
                    0x31,0x03,0x33,0x03,0x17,0x03,0x22,0x03,
                    0x25,0x03,0x27,0x03,0x12,0x03,0x15,0x03,
                    0x21,0x03,0x23,0x03,0x26,0x03,0x31,0x03,
                    0x33,0x03,0x36,0x03,0x32,0x03,0x33,0x03,
                    0x35,0x04,0x33,0x04,0x32,0x03,0x27,0x03,
                    0x25,0x03,0x16,0x03,0x21,0x03,0x23,0x03,
                    0x26,0x03,0x31,0x03,0x33,0x03,0x17,0x03,
                    0x22,0x03,0x25,0x03,0x27,0x03,0x32,0x03,
                    0x35,0x03,0x21,0x03,0x23,0x03,0x26,0x03,
                    0x31,0x03,0x33,0x03,0x36,0x03,0x32,0x03,
                    0x33,0x03,0x35,0x04,0x33,0x04,0x32,0x03,
                    0x27,0x03,0x25,0x03,0x26,0x02,0x33,0x02,
                    0x33,0x02,0x27,0x02,0x33,0x02,0x33,0x02,
                    0x31,0x02,0x33,0x02,0x33,0x02,0x32,0x03,
                    0x33,0x03,0x35,0x04,0x33,0x04,0x27,0x03,
                    0x25,0x03,0x26,0x02,0x33,0x02,0x33,0x02,
                    0x27,0x02,0x33,0x02,0x33,0x02,0x24,0x03,
                    0x26,0x03,0x32,0x03,0x34,0x03,0x35,0x03,
                    0x34,0x03,0x37,0x02,0x36,0x01,0x33,0x02,
                    0x26,0x03,0x27,0x03,0x31,0x03,0x33,0x03,
                    0x32,0x02,0x25,0x02,0x32,0x02,0x31,0x02,
                    0x27,0x03,0x31,0x03,0x27,0x03,0x25,0x03,
                    0x23,0x02,0x26,0x02,0x26,0x02,0x33,0x02,
                    0x26,0x03,0x27,0x03,0x31,0x03,0x35,0x03,
                    0x34,0x02,0x32,0x02,0x32,0x03,0x33,0x03,
                    0x31,0x03,0x27,0x03,0x25,0x03,0x27,0x02,
                    0x26,0x00,0x33,0x02,0x26,0x03,0x27,0x03,
                    0x31,0x03,0x33,0x03,0x32,0x02,0x25,0x02,
                    0x32,0x02,0x31,0x02,0x27,0x03,0x31,0x03,
                    0x27,0x03,0x25,0x03,0x23,0x02,0x26,0x02,
                    0x26,0x02,0x33,0x02,0x26,0x03,0x27,0x03,
                    0x31,0x03,0x35,0x03,0x34,0x02,0x32,0x02,
                    0x32,0x03,0x33,0x03,0x31,0x03,0x27,0x03,
                    0x25,0x02,0x27,0x02,0x26,0x00,0x00,0x00 };

char Sound[]     ={ 0x32,0x02,0x00,0x00};

int main()
{
    PlayBGM(Music_Code,false);
    Delay(8000000);
    StopBGM();
    Delay(8000000);
    StartBGM();
    Delay(8000000);
    PlaySound(Sound,1);
    while(1);
    return 0;
}