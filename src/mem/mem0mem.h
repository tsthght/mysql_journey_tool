#ifndef __MEM0MEM_H__
#define __MEM0MEM_H__

#include "com0inc.h"
#include "univ.h"
#include "ut0lst.h"

typedef struct mem_block_info_t mem_block_t;
/* info in every heap block  */
struct mem_block_info_t{
	ulint magic_n;
	char file_name[8];
	ulint line;
	UT_LIST_NODE_T(mem_block_t) base;//only used in first block
	UT_LIST_NODE_T(mem_block_t) list;//link the list
	ulint len;//physical length of this block in bytes
	ulint total_size;//physical length of all blocks in the heap. Only defined in the base node and is set to ULINT_UNDEFINED in others.
	ulint type;
	ulint free;//offset of the first free position in the block
	ulint start;
};

#endif
