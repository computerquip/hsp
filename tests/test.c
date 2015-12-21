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
	int input_fd = open("Drawer.hlsl", O_RDONLY);
	
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
	struct HSPToken token = hsp_lex(lexer);
	struct HSPParser *parser;
	
	while (token.id != TK_EndOfFile) {
		
		if (token.id == TK_Invalid) {
			printf("Invalid Token - \"%.*s\"\n",
			       token.lexeme.size, token.lexeme.data);
			break;
		} else {
			printf("Valid Token: %s - \"%.*s\"\n", 
			       GET_TOKEN_STRING(token.id),
			       token.lexeme.size, token.lexeme.data);
		}
		
		token = hsp_lex(lexer);
	}
	
	printf("String succesfully analyzed!\n");
	
	/* Parser Test */
	hsp_reset_lexer(lexer);
	
	parser = hsp_create_parser(lexer);
	if (!hsp_parse(parser))
		printf("Failed to parse string!\n");
	else    
		printf("String succesfully parsed!\n");
	
	hsp_destroy_parser(parser);
	hsp_destroy_lexer(lexer);
	
	return 0;
}