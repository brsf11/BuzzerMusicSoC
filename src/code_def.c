#include"code_def.h"

void Delay(int interval)
{
    int i = 0;
    while(1) 
		{
			i = i + 1;
			if(i == interval) break;
		}
}

void PlayBGM(char* BeginAddr,bool isCyl)
{
    Buzzer->BuzzerBGMAddr = (uint32_t)BeginAddr;
    if(isCyl)
    {
        Buzzer->BuzzerBGMCtr = 6;
    }
    else
    {
        Buzzer->BuzzerBGMCtr = 2;
    }
}

void StopBGM()
{
    Buzzer->BuzzerBGMCtr |= 1;
}

void StartBGM()
{
    Buzzer->BuzzerBGMCtr &= 0xFFFFFFFE;
}

void PlaySound(char* BeginAddr,uint32_t Pri)
{
    Buzzer->BuzzerSoundAddr = (uint32_t)BeginAddr;
    Buzzer->BuzzerSoundCtr  = (Pri << 1) + 1;
}

void ResetBGM()
{
    Buzzer->BuzzerBGMCtr &= 0;
}
