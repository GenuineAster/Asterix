#pragma once
typedef uint32_t page;

struct page_table
{
	page pages[1024];
};

struct page_directory
{
	page_table *tables[1024];
	uint32_t tables_physical[1024];
	uint32_t physical_addr;
};

void initialize_paging();
void switch_page_directory(page_directory &p);
page &get_page(uint32_t addr, int make, page_directory &dir);
