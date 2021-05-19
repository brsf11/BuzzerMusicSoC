#include<stdint.h>
#include<stdbool.h>

//INTERRUPT DEF
#define NVIC_CTRL_ADDR (*(volatile unsigned *)0xe000e100)

//Buzzer DEF
typedef struct
{
    volatile uint32_t BuzzerBGMAddr;
    volatile uint32_t BuzzerBGMCtr;
    volatile uint32_t BuzzerSoundAddr;
    volatile uint32_t BuzzerSoundCtr;
}BuzzerStr;

#define Buzzer_BASE 0x40000000
#define Buzzer ((BuzzerStr *)Buzzer_BASE)

void Delay(int interval);
void PlayBGM(char* BeginAddr,bool isCyl);
void StopBGM(void);
void StartBGM(void);
void PlaySound(char* BeginAddr,uint32_t Pri);
