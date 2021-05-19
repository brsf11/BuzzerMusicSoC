#include <stdint.h>
#include "code_def.h"

extern bool isPlaying;

void KEY(void)
{
	if(isPlaying)
	{
		StopBGM();
		isPlaying = false;
	}
	else
	{
		StartBGM();
		isPlaying = true;
	}
}
