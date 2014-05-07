#include <cstddef>
#include <cstdint>
#include <multiboot.h>
#include <kernel/assembly.h>

constexpr size_t VGA_WIDTH = 80;
constexpr size_t VGA_HEIGHT = 24;

/* Hardware text mode color constants. */
enum Color
{
	Black = 0,
	Blue,
	Green,
	Cyan,
	Red,
	Magenta,
	Brown,
	LightGray,
	LightGrey = LightGray,
	DarkGray,
	DarkGrey = DarkGray,
	LightBlue,
	LightGreen,
	LightCyan,
	LightRed,
	LightMagenta,
	LightBrown,
	White
};


size_t strlen(const char* bytes)
{
	size_t i;
	for(i=0;bytes[i]!=0 || i == 31;++i);
	return i;
}
 
class Terminal
{
public: 
	size_t row;
	size_t column;
	uint8_t color;
	uint16_t* buffer;
	 
	void initialize()
	{
		row = get_cursor_pos_y();
		column = get_cursor_pos_x();
		set_color(Color::White, Color::Black);
		buffer = (uint16_t*) 0xB8000;
	}
	 
	void set_color(Color foreground, Color background)
	{
		color = foreground | background << 4;
	}

	void putc(const char &byte)
	{
		if(byte == '\n')
		{
			++row;
			return;
		}
		else if(byte == '\r')
		{
			column = 0;
			return;
		}
		else
		{
			size_t index     = row * 80 + column;
			uint16_t vgadata = (uint16_t)byte | ((uint16_t)color<<8);
			buffer[index] = vgadata;
		}

		if(++column == 80)
		{
			column = 0;
			if(++row == 24)
				row = 0;
		}
	}
	 
	void puts(const char* bytes)
	{
		auto length = strlen(bytes);
		for(auto i=0;i<length || i == 31;++i)
			putc(bytes[i]);
	}
};

Terminal terminal;

extern "C"
void kernel_main()
{
	terminal.initialize();
	terminal.puts("Hello, kernel World!\r\n");
}
