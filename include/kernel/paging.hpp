#pragma once
#include <cstddef>
#include <cstdint>

#if  defined(ASTERIX_x86_64)

typedef uint64_t page_t;
typedef page_t page_table_t[0x200];
typedef page_table_t *page_directory_t[0x200];
typedef page_directory_t *page_directory_pointer_t[0x200];
typedef page_directory_pointer_t *pml4_t[0x200];

#elif defined(ASTERIX_NOARCH)
#endif
