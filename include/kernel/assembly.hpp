#pragma once
#include <kernel/paging.hpp>
extern "C"
{
	void cpp_test();
	void set_page_directory(page_directory *dir);
	void enable_paging();
	char get_cursor_pos_x();
	char get_cursor_pos_y();
}