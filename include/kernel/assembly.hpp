#pragma once
extern "C"
{
	void set_cr0(uint32_t cr0);
	uint32_t get_cr0();
	void set_cr1(uint32_t cr1);
	uint32_t get_cr1();
	void set_cr2(uint32_t cr2);
	uint32_t get_cr2();
	void set_cr3(uint32_t cr3);
	uint32_t get_cr3();
	void set_cr4(uint32_t cr4);
	uint32_t get_cr4();
}
