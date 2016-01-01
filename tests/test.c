#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>

#include "lexer/Lexer.h"
#include "parser/Parser.h"

int main(void)
{
	int input_fd = open("test.hlsl", O_RDONLY);

	struct stat input_stat;

	if (!input_fd) {
		printf("Failed to open Drawer.hlsl!\n");
		return 1;
	}

	if (fstat(input_fd, &input_stat) == -1) {
		printf("Failed to stat input: %s\n", strerror(errno));
		return 2;
	}

	/* We know Drawer.hlsl is a regular file. */
	void * input = mmap(0, input_stat.st_size, PROT_READ, MAP_SHARED, input_fd, 0);

	if (input == MAP_FAILED) {
		printf("Failed to map input file: %s\n", strerror(errno));
		return 3;
	}

	struct HSPLexer *lexer = hsp_create_lexer(input, input_stat.st_size);
	int token = hsp_lex(lexer);

	while (token != EOFILE) {
		printf("L:%d C:%d Token: %s\n",
			hsp_get_line(lexer), hsp_get_column(lexer),
			LLgetSymbol(token));

		token = hsp_lex(lexer);
	}

	printf("Token: %s\n", LLgetSymbol(token));

	printf("String analyzed!\n");

	/* Parser Test */
	hsp_reset_lexer(lexer);

	hsp_parse(lexer);

	hsp_destroy_lexer(lexer);

	return 0;
}
