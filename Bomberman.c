#include <stdio.h>
#include <stdlib.h>

/* print the bombMap array */

void printMap (char ** array, int row, int column)
{
	printf("\n");
	for (int i = 0; i < row; ++i)
	{
		for (int j = 0; j < column; ++j)
		{
			printf(" %c ",array[i][j]);
		}
		printf("\n");
	}
	printf("\n");
}

void sprinkleBomb (char ** array, int row, int column)
{
	//2 - sprink the bomb
	for (int i = 0; i < row; ++i)
	{
		for (int j = 0; j < column; ++j)
		{
			if (array[i][j] != 'o')
			{
				array[i][j] = 'o';
			}
		}
	}
}

void bombing (char ** array, char ** controlArray, int row, int column)
{
	//3- detonate first bomb
	for (int i = 0; i < row; ++i)
	{
		for (int j = 0; j < column; ++j)
		{
			if (array[i][j] == 'o' && controlArray[i][j] == 'x')
			{
				array[i][j]   = '.';

				if (j < column - 1)
				{
					array[i][j+1] = '.';
				}

				if (j > 0)
				{
					array[i][j-1] = '.';
				}
				
				if (i > 0)
				{
					array[i-1][j] = '.';
				}
				
				if (i < row - 1)
				{
					array[i+1][j] = '.';
				}
			}

			else if (controlArray[i][j] == 'x')
			{
				controlArray[i][j] = 'y';
			}
		}
	}
}

int main (int argc, char const *argv[])
{
	int size1 = 0;
	int size2 = 0;
	char cellContent;

	printf("Enter size of row: ");
	scanf("%d",&size1);
	printf("Enter size of column: ");
	scanf("%d",&size2);

	char ** bombMap = (char **) malloc(size1 * sizeof(char *));
	char ** timeFlag = (char **) malloc(size1 * sizeof(char *));

	for (int i = 0; i < size1; ++i)
	{
		bombMap[i] = (char *) malloc(size2 * sizeof(char));
		timeFlag[i] = (char *) malloc(size2 * sizeof(char));
	}
	// ignore the enter (\n) character
	getchar();
	// 1 - take content of bombMap
	for (int i = 0; i < size1; ++i)
	{
		for (int j = 0; j < size2; ++j)
		{
			scanf("%c",&cellContent);

			bombMap[i][j] = cellContent;

			if (bombMap[i][j] == 'o')
			{
				timeFlag[i][j] = 'x';
			}

			else
			{
				timeFlag[i][j] = 'y';
			}
		}
	}
	printMap(bombMap,size1,size2);
	sprinkleBomb(bombMap,size1,size2);
	bombing(bombMap,timeFlag,size1,size2);
	printMap(bombMap,size1,size2);
	
	return 0;
}