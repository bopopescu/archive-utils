#define _GNU_SOURCE 1
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define TEST_FILE	"BIGFILE"
#define PAGE_SIZE	(4096)
#define CONCURRENCY	(10)
#define PER_THREAD_IOS (10000)


/*															 
 *
 * - writes page size chunks to random offsets in a file															 
 * - uses the same seed for the random number generator each		 
 *	time in order to benchark the same pattern for comparison														 
 * - uses direct I/O to bypass the pagecache entirely			
 *															 
 */

int main()
{
	int x, fd, status, thread;
	pid_t t;
	float slots;
	off_t offset, slot;
	void *buf;

	fd=open(TEST_FILE, O_RDWR|O_DIRECT);
	if (fd == -1)
	{
		perror("error opening file");
		exit(1);
	}
	struct stat s;
	status = stat(TEST_FILE, &s);
	if (status == -1)
	{
		perror("stat failed");
		exit(2);
	}

	if(s.st_size < PAGE_SIZE)
	{
		perror("file too small");
		exit(3);
	}
	slots = s.st_size / PAGE_SIZE;

	// printf("file size: %ld slots: %.0f\n", s.st_size, slots);
	/*
	 *direct I/O requires a buffer that is sector-aligned
	 */
	status = posix_memalign(&buf, 512, PAGE_SIZE);
	if(status)
	{
		perror("posix_memalign failed");
		exit(4);
	}

	for(thread=0; thread < CONCURRENCY; thread++)
	{
		t = fork();
		if(t == 0) /* child */
			break;
	}
	if(t == 0) /* child */
	{
		memset(buf, thread, PAGE_SIZE);
		 /* I want each thread to produce its own, distinct I/O pattern
		*but each thread should produce the same pattern every time
		*this way comparing and contrasting run times
		*will be more predictable
		*/
		srand((thread + 1) * 1319);
		for(x=0; x < PER_THREAD_IOS; x++)
		{
			slot = (off_t) (slots * (rand() / (RAND_MAX + 1.0)));
			offset = PAGE_SIZE * slot;
			status = pwrite(fd, buf, PAGE_SIZE, offset);
			if (status == -1) {
				fprintf(stderr, "write failed at offset: %ld\n", offset); 
				exit(9);
			}
			
			// printf("thread: %d writing to offset: %ld\n", thread, offset);
		}
		_exit(0);
	}
	else /* parent */
	{
		status=0;
		for(thread=0; thread < CONCURRENCY; thread++)
		{
			// printf("Waiting for thread #%d to finish\n", thread);
			wait(&status);
			if (status != 0) {
				fprintf(stderr, "childprocess failed with status=%d\n",status); 
				free(buf);
				close(fd);
				exit (11);
			}
		}

	}
	free(buf);
	close(fd);
	return 0;
}
