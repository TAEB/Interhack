/* 
 * Copyright (c) 2006, Shawn M Moore and Sean Kelly
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are  
 * met:
 *
 * 1. Redistributions of source code must retain the above copyright 
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright 
 *    notice, this list of conditions and the following disclaimer in the 
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER 
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* version 1.2, 20:11 10 Nov 06 */

/*
 * changelog: 1.1 - removed conditional compilation
 *                  default behavior is now interactive mode
 *                  removed figuring out all tunes
 *                  see mastermind-dev.c (aka 1.0) if you want the old code
 *                  some small fixes elsewhere
 *            1.2 - now designed to run solely with Rodney
 */

#define NUM_TUNES (16807)
#define FIRST     (0)
#define MEDIAN    (1)
#define BEST      (2)
#define METHOD    (MEDIAN)

char unhash_table[NUM_TUNES][5]; /* go from [0, 16807) to AAAAA..GGGGG */
char is_possible[NUM_TUNES];

char guess_this[6];

int num_possible; /* global only for interactive mode, could put this in an 
                     ifdef but why bother, seriously */

char t['H'];
char c['H'];

/* hash (aka convert from base septal (septinary?) to decimal) five notes */
int hash_notes(char a, char b, char c, char d, char e)
{
  return (e - 'A') + 7 * (
         (d - 'A') + 7 * (
         (c - 'A') + 7 * (
         (b - 'A') + 7 * 
         (a - 'A')))); 
}

/* hash a five-char array */
int hash_tune(char *tune)
{
  return (tune[4] - 'A') + 7 * (
         (tune[3] - 'A') + 7 * (
         (tune[2] - 'A') + 7 * (
         (tune[1] - 'A') + 7 *
         (tune[0] - 'A')))); 
}

/* warning: does NOT null-terminate output (for super speed, y'see) */
void unhash(char *out, int hash)
{
  out[0] = out[1] = out[2] = out[3] = out[4] = 'A';

  while (hash >= 2401) { ++out[0]; hash -= 2401; }
  while (hash >= 343)  { ++out[1]; hash -= 343;  }
  while (hash >= 49)   { ++out[2]; hash -= 49;   }
  while (hash >= 7)    { ++out[3]; hash -= 7;    }
  
  out[4] += hash;
}

int judge(char *correct, char *guess)
{
  int gears = 0;
  int tumblers = 0;

	t['A'] = t['B'] = t['C'] = t['D'] = t['E'] = t['F'] = t['G'] = 0;
	c['A'] = c['B'] = c['C'] = c['D'] = c['E'] = c['F'] = c['G'] = 0;

	/* unrolled lol-loop */
	if (correct[0] == guess[0]) 
		++gears;
	else
	{
		++c[correct[0]];
		++t[guess[0]];
	}
	
	if (correct[1] == guess[1]) 
		++gears;
	else
	{
		++c[correct[1]];
		++t[guess[1]];
	}
	
	if (correct[2] == guess[2]) 
		++gears;
	else
	{
		++c[correct[2]];
		++t[guess[2]];
	}

	if (correct[3] == guess[3]) 
		++gears;
	else
	{
		++c[correct[3]];
		++t[guess[3]];
	}

	if (correct[4] == guess[4]) 
		++gears;
	else
	{
		++c[correct[4]];
		++t[guess[4]];
	}

	while (t['A']-- > 0 && c['A']-- > 0) ++tumblers;
	while (t['B']-- > 0 && c['B']-- > 0) ++tumblers;
	while (t['C']-- > 0 && c['C']-- > 0) ++tumblers;
	while (t['D']-- > 0 && c['D']-- > 0) ++tumblers;
	while (t['E']-- > 0 && c['E']-- > 0) ++tumblers;
	while (t['F']-- > 0 && c['F']-- > 0) ++tumblers;
	while (t['G']-- > 0 && c['G']-- > 0) ++tumblers;

  /* now that's what I call compact! */
  return (gears << 3) + tumblers;
}

int next_guess(int guesses)
{
  int i, j;

#if METHOD == FIRST
  /* simple algorithm: take the first possible tune */
  
  if (guesses == 1)
    return hash_tune("AABBC");
  for (i = 0; i < NUM_TUNES; ++i)
    if (is_possible[i])
      break;
#endif

#if METHOD == MEDIAN
  /* 
   * slightly more complicated algorithm: take (close to) the median 
   * possible tune 
   *
   * I checked it out, is_possible[j] is always true (as I write this) 
   * even if next_j is initially 0, though this isn't necessarily going 
   * to be the case if anything changes 
   */
  int next_j = 0;

  if (guesses == 1)
    return hash_tune("AABBC");
  for (i = j = 0; i < NUM_TUNES; ++i)
  {
    if (is_possible[i])
    {
      if (next_j)
      {
        while (!is_possible[++j])
          ;
      }
      next_j = !next_j;
    }
  }
  i = j;
#endif

#if METHOD == BEST
/* Knuth powah: take the best possible tune greedily */
  int best = -1;
  int best_cnt = 20000;
  int worst_case;
  int leftover[42];
  
  if (guesses == 1)
    return hash_tune("AABBC");

  for (i = 0; i < NUM_TUNES; ++i)
  {
    if (!is_possible[i])
      continue;
    for (j = 0; j <= 40; ++j)
      leftover[j] = 0;
 
    for (j = 0; j < NUM_TUNES; ++j)
    {
      if (!is_possible[j])
        continue;
      ++leftover[judge(unhash_table[j], unhash_table[i])];
    }

    worst_case = 0;
    for (j = 0; j <= 40; ++j)
      if (leftover[j] > worst_case)
        worst_case = leftover[j];

    if (worst_case < best_cnt)
    {
      best_cnt = worst_case;
      best = i;
    }
  }

  i = best;
#endif

  return i;
}

void eliminate(int played, int result)
{
  int j;

  /* begin eliminating impossible tunes */
  for (j = 0; j < NUM_TUNES; ++j)
  {
    if (!is_possible[j])
      continue;
    if (judge(unhash_table[j], unhash_table[played]) != result)
    {
      is_possible[j] = 0;
      --num_possible;
    }
  }
}

int main(int argc, char *argv[])
{
  int i;

  for (i = 0; i < NUM_TUNES; ++i)
    unhash(unhash_table[i], i);

  strcpy(guess_this, "AABBC");

  num_possible = NUM_TUNES;
  for (i = 0; i < NUM_TUNES; ++i)
    is_possible[i] = 1;

  for (i = 1; i < argc; ++i)
	{
		int g = next_guess(i);
    int result = ((argv[i][0]-'0') << 3) + (argv[i][1]-'0');
		eliminate(g, result);
	}

  if (num_possible < 1)
	{
		printf("ACK!");
	}
	else if (num_possible == 1)
	{
		for (i = 0; i < NUM_TUNES; ++i)
			if (is_possible[i])
				break;
		printf("%.5s 1\n", unhash_table[i]);
	}
	else
	{
	  printf("%.5s %d\n", unhash_table[next_guess(i)], num_possible);
	}

  return 0;
}

