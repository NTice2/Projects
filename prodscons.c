//Code Created by Nic Tice
//Using pthread to solve the producer consumer problem
//Utilizing mutex to keep my code thread-safe
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define BUFFER_SIZE 10

int buffer[BUFFER_SIZE];		//creating buffer
int count = 0;
int in = 0;
int out = 0;
int produced_count = 0;
int consumed_count = 0;
pthread_mutex_t mutex;
pthread_cond_t full;
pthread_cond_t empty;


void *producer(void *arg) {
    while (1) { 			//Outputting Buffer status when full
        pthread_mutex_lock(&mutex);
        if (count == BUFFER_SIZE) {
            printf("Buffer is full, Producer %ld waiting\n", (long)arg);
            pthread_cond_wait(&empty, &mutex);
        }
        buffer[in] = produced_count++;
        printf("Producer %ld producing item %d\n", (long)arg, buffer[in]);	
        in = (in + 1) % BUFFER_SIZE;	//Outputting status of producer threads producing
        sleep(1);
        count++;
        pthread_cond_signal(&full);
        pthread_mutex_unlock(&mutex);
        sleep(1);
        if(produced_count >= 30)
            break;
    }
}

void *consumer(void *arg) {
    while (1) {				//Outputting Buffer status when full
        pthread_mutex_lock(&mutex);
        if (count == 0) {
            printf("Buffer is empty, Consumer %ld waiting\n", (long)arg);
            pthread_cond_wait(&full, &mutex);
        }
        int data = buffer[out];
        out = (out + 1) % BUFFER_SIZE;
        count--;
        printf("Consumer %ld consuming item %d\n", (long)arg, data);
        consumed_count++;		//Outputting status of consumer threads consuming
        pthread_cond_signal(&empty);
        pthread_mutex_unlock(&mutex);
        sleep(1);
        if(consumed_count >= 30)
            break;
    }
}

int main(int argc, char *argv[]) {
    pthread_t producer_thread[3], consumer_thread[3];	//Creating 3 Producers and Consumers
    pthread_mutex_init(&mutex, NULL);		
    pthread_cond_init(&full, NULL);
    pthread_cond_init(&empty, NULL);
    for(int i=0;i<3;i++)
        pthread_create(&producer_thread[i], NULL, producer, (void*)(long)i);
    for(int i=0;i<3;i++)
        pthread_create(&consumer_thread[i], NULL, consumer, (void*)(long)i);
    for(int i=0;i<3;i++)
        pthread_join(producer_thread[i], NULL);
    for(int i=0;i<3;i++)
        pthread_join(consumer_thread[i], NULL);
    pthread_mutex_destroy(&mutex);
    return 0;
}






