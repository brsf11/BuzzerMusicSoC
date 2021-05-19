#include <stdint.h>
#include "code_def.h"

uint32_t key_flag;

void KEY(void)
{
	key_flag = 1;
}
