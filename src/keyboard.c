#include <stdint.h>
#include "code_def.h"

extern bool isPlaying;
extern bool isStop;
extern char* Music_1;
extern char* Music_2;
extern uint32_t Music_num;

void KEY(void)
{
	// uint32_t KeyReg;

	// KeyReg = KeyboardReg;
	// if(!(KeyReg & 0x00010000))
	// {
	// 	if(isPlaying)
	// 	{
	// 		isStop = true;
	// 		StopBGM();
	// 	}
	// 	else
	// 	{
	// 		if(isStop)
	// 		{
	// 			isStop = false;
	// 			StartBGM();
	// 		}
	// 		else
	// 		{
	// 			if(Music_num)
	// 			{
	// 				PlayBGM(Music_2,true);
	// 			}
	// 			else
	// 			{
	// 				PlayBGM(Music_1,true);
	// 			}
	// 		}
	// 	}
	// }

	// if(!(KeyReg & 0x00020000))
	// {
	// 	if(Music_num)
	// 	{
	// 		Music_num = 0;
	// 		ResetBGM();
	// 		PlayBGM(Music_1,true);
	// 	}
	// 	else
	// 	{
	// 		Music_num = 1;
	// 		ResetBGM();
	// 		PlayBGM(Music_2,true);
	// 	}
	// }

	// if(Music_num == 1)
	// {
	// 	Delay(10000);
	// 	ResetBGM();
	// 	Delay(10000);
	// 	PlayBGM(Music_1+2,true);
	// 	Music_num = 0;
	// }
	// else
	//{
		Delay(10000);
		ResetBGM();
		Delay(10000);
		PlayBGM(Music_1,true);
		Music_num = 1;
	//}
}
