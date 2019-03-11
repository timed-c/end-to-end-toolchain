# 1 "./test1.cil.c"
# 1 "/home/saranya/Dokument/e2e/profile-test//"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "./test1.cil.c"
# 216 "/usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h"
typedef unsigned long size_t;
# 131 "/usr/include/x86_64-linux-gnu/bits/types.h"
typedef long __off_t;
# 132 "/usr/include/x86_64-linux-gnu/bits/types.h"
typedef long __off64_t;
# 133 "/usr/include/x86_64-linux-gnu/bits/types.h"
typedef int __pid_t;
# 139 "/usr/include/x86_64-linux-gnu/bits/types.h"
typedef long __time_t;
# 147 "/usr/include/x86_64-linux-gnu/bits/types.h"
typedef int __clockid_t;
# 150 "/usr/include/x86_64-linux-gnu/bits/types.h"
typedef void *__timer_t;
# 175 "/usr/include/x86_64-linux-gnu/bits/types.h"
typedef long __syscall_slong_t;
# 44 "/usr/include/stdio.h"
struct _IO_FILE;
# 44 "/usr/include/stdio.h"
struct _IO_FILE;
# 48 "/usr/include/stdio.h"
typedef struct _IO_FILE FILE;
# 144 "/usr/include/libio.h"
struct _IO_FILE;
# 150 "/usr/include/libio.h"
typedef void _IO_lock_t;
# 156 "/usr/include/libio.h"
struct _IO_marker {
   struct _IO_marker *_next ;
   struct _IO_FILE *_sbuf ;
   int _pos ;
};
# 241 "/usr/include/libio.h"
struct _IO_FILE {
   int _flags ;
   char *_IO_read_ptr ;
   char *_IO_read_end ;
   char *_IO_read_base ;
   char *_IO_write_base ;
   char *_IO_write_ptr ;
   char *_IO_write_end ;
   char *_IO_buf_base ;
   char *_IO_buf_end ;
   char *_IO_save_base ;
   char *_IO_backup_base ;
   char *_IO_save_end ;
   struct _IO_marker *_markers ;
   struct _IO_FILE *_chain ;
   int _fileno ;
   int _flags2 ;
   __off_t _old_offset ;
   unsigned short _cur_column ;
   signed char _vtable_offset ;
   char _shortbuf[1] ;
   _IO_lock_t *_lock ;
   __off64_t _offset ;
   void *__pad1 ;
   void *__pad2 ;
   void *__pad3 ;
   void *__pad4 ;
   size_t __pad5 ;
   int _mode ;
   char _unused2[(15UL * sizeof(int ) - 4UL * sizeof(void *)) - sizeof(size_t )] ;
};
# 98 "/usr/include/x86_64-linux-gnu/sys/types.h"
typedef __pid_t pid_t;
# 91 "/usr/include/time.h"
typedef __clockid_t clockid_t;
# 103 "/usr/include/time.h"
typedef __timer_t timer_t;
# 27 "/usr/include/x86_64-linux-gnu/bits/sigset.h"
struct __anonstruct___sigset_t_15 {
   unsigned long __val[1024UL / (8UL * sizeof(unsigned long ))] ;
};
# 27 "/usr/include/x86_64-linux-gnu/bits/sigset.h"
typedef struct __anonstruct___sigset_t_15 __sigset_t;
# 37 "/usr/include/x86_64-linux-gnu/sys/select.h"
typedef __sigset_t sigset_t;
# 120 "/usr/include/time.h"
struct timespec {
   __time_t tv_sec ;
   __syscall_slong_t tv_nsec ;
};
# 60 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
typedef unsigned long pthread_t;
# 63 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
union pthread_attr_t {
   char __size[56] ;
   long __align ;
};
# 69 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
typedef union pthread_attr_t pthread_attr_t;
# 75 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
struct __pthread_internal_list {
   struct __pthread_internal_list *__prev ;
   struct __pthread_internal_list *__next ;
};
# 75 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
typedef struct __pthread_internal_list __pthread_list_t;
# 90 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
struct __pthread_mutex_s {
   int __lock ;
   unsigned int __count ;
   int __owner ;
   unsigned int __nusers ;
   int __kind ;
   short __spins ;
   short __elision ;
   __pthread_list_t __list ;
};
# 90 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
union __anonunion_pthread_mutex_t_17 {
   struct __pthread_mutex_s __data ;
   char __size[40] ;
   long __align ;
};
# 90 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
typedef union __anonunion_pthread_mutex_t_17 pthread_mutex_t;
# 139 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
struct __anonstruct___data_20 {
   int __lock ;
   unsigned int __futex ;
   unsigned long long __total_seq ;
   unsigned long long __wakeup_seq ;
   unsigned long long __woken_seq ;
   void *__mutex ;
   unsigned int __nwaiters ;
   unsigned int __broadcast_seq ;
};
# 139 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
union __anonunion_pthread_cond_t_19 {
   struct __anonstruct___data_20 __data ;
   char __size[48] ;
   long long __align ;
};
# 139 "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h"
typedef union __anonunion_pthread_cond_t_19 pthread_cond_t;
# 31 "/usr/include/x86_64-linux-gnu/bits/setjmp.h"
typedef long __jmp_buf[8];
# 34 "/usr/include/setjmp.h"
struct __jmp_buf_tag {
   __jmp_buf __jmpbuf ;
   int __mask_was_saved ;
   __sigset_t __saved_mask ;
};
# 48 "/usr/include/setjmp.h"
typedef struct __jmp_buf_tag jmp_buf[1];
# 92 "/usr/include/setjmp.h"
typedef struct __jmp_buf_tag sigjmp_buf[1];
# 742 "/usr/include/pthread.h"
struct __jmp_buf_tag;
# 25 "/usr/include/asm-generic/int-ll64.h"
typedef int __s32;
# 26 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned int __u32;
# 30 "/usr/include/asm-generic/int-ll64.h"
typedef unsigned long long __u64;
# 48 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct threadqueue {
   pthread_mutex_t mutex ;
   pthread_cond_t cond ;
};
# 97 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct tp_struct {
   int waiting ;
   jmp_buf env ;
   timer_t *tmr ;
};
# 117 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct cbm {
   int use ;
   int data ;
   struct cbm *nextc ;
};
# 117 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
typedef struct cbm cbm;
# 123 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct cab_ds {
   struct cbm *free ;
   struct cbm *mrb ;
   int maxcbm ;
};
# 133 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct fifolist {
   int data ;
   struct timespec ts ;
   struct fifolist *nextf ;
   pthread_mutex_t mutx ;
};
# 140 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct sched_attr {
   __u32 size ;
   __u32 sched_policy ;
   __u64 sched_flags ;
   __s32 sched_nice ;
   __u32 __sched_priority ;
   __u64 sched_runtime ;
   __u64 sched_deadline ;
   __u64 sched_period ;
};
# 104 "/usr/include/getopt.h"
struct option {
   char const *name ;
   int has_arg ;
   int *flag ;
   int val ;
};
# 272 "/usr/include/stdio.h"
extern FILE *fopen(char const * __restrict __filename , char const * __restrict __modes ) ;
# 362 "/usr/include/stdio.h"
extern int printf(char const * __restrict __format , ...) ;
# 764 "/usr/include/stdlib.h"
extern void ( __attribute__((__nonnull__(1,4))) qsort)(void *__base , size_t __nmemb , size_t __size , int (*__compar)(void const * , void const * ) ) ;
# 759 "/usr/include/unistd.h"
extern __attribute__((__nothrow__)) __pid_t fork(void) ;
# 1061 "/usr/include/unistd.h"
extern __attribute__((__nothrow__)) long ( __attribute__((__leaf__)) syscall)(long __sysno , ...) ;
# 342 "/usr/include/time.h"
extern __attribute__((__nothrow__)) int ( __attribute__((__leaf__)) clock_gettime)(clockid_t __clock_id , struct timespec *__tp ) ;
# 59 "/usr/include/setjmp.h"
extern __attribute__((__nothrow__)) int __sigsetjmp(struct __jmp_buf_tag *__env , int __savemask ) ;
# 233 "/usr/include/pthread.h"
extern __attribute__((__nothrow__)) int ( __attribute__((__nonnull__(1,3))) pthread_create)(pthread_t * __restrict __newthread , pthread_attr_t const * __restrict __attr , void *(*__start_routine)(void * ) , void * __restrict __arg ) ;
# 250 "/usr/include/pthread.h"
extern int pthread_join(pthread_t __th , void **__thread_return ) ;
# 22 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
int policy = 0;
# 88 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct timespec *timepecptr ;
# 89 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
timer_t ftimer ;
# 90 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
sigset_t sigtype ;
# 91 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern int ktc_critical_end(sigset_t *orig_mask ) ;
# 92 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern int ktc_critical_start(sigset_t *orig_mask ) ;
# 93 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern int ktc_set_sched(int policy , int runtime , int deadline , int period ) ;
# 104 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
_Bool boolvar ;
# 105 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct tp_struct tp_struct_data ;
# 106 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
int list_pr[500] = { 4};
# 107 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
int list_dl[500] = { 4};
# 108 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern void ktc_create_timer(timer_t *ktctimer , struct tp_struct *tp , int num ) ;
# 109 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern int ktc_start_time_init(struct timespec *start_time ) ;
# 110 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern long ktc_sdelay_init(int deadline , int period , int unit , struct timespec *start_time , int id ) ;
# 111 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern long ktc_gettime(int unit ) ;
# 112 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern long ktc_fdelay_init(int interval , int period , int unit , struct timespec *start_time , int id , int num , int retjmp ) ;
# 113 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern long ktc_block_signal(int n ) ;
# 114 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
sigjmp_buf buf_struct ;
# 130 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
cbm cabmsgv ;
# 131 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct cab_ds cabdsv ;
# 158 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct sched_attr sae ;
# 159 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct fifolist fifoex ;
# 161 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern int compare_qsort(void const *elem1 , void const *elem2 ) ;
# 162 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
int populatelist(int num ) ;
# 163 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern struct cbm *ktc_htc_reserve(struct cab_ds *cab ) ;
# 164 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern void ktc_htc_putmes(struct cab_ds *cab , struct cbm *buffer ) ;
# 165 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern cbm *ktc_htc_getmes(struct cab_ds *cab ) ;
# 166 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern void ktc_htc_unget(struct cab_ds *cab , cbm *buffer ) ;
# 167 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern int ktc_fifo_init(struct threadqueue *queue ) ;
# 168 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern void ktc_fifo_write(struct threadqueue *queue , void *fifolistt , int *fifocount , int *fifotail , void *data , int size ) ;
# 169 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern void ktc_fifo_read(struct threadqueue *queue , void *fifolistt , int *fifocount , int *fifotail , void *data , int size , struct timespec *wt ) ;
# 170 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern void ktc_simpson(int *sdata , int *tdata ) ;
# 172 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
size_t s ;
# 173 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
struct option o ;
# 174 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
__inline static int sched_getattr(pid_t pid , struct sched_attr *attr , unsigned int size , unsigned int flags )
{
  int tmp ;

  {
# 174 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
  tmp = (int )syscall(315, pid, attr, size, flags);
# 174 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
  return (tmp);
}
}
# 233 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
extern int ktc_fdelay_start_timer(int interval , int unit , timer_t ktctimer , struct timespec *start_time ) ;
# 234 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
pthread_t pthread_id_example ;
# 261 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 262 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 263 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 264 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 265 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 266 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 267 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 268 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 269 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 270 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 271 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 272 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 273 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 274 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 275 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 276 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 277 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 278 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 279 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 280 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 281 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 282 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 283 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 284 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 285 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 286 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 287 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 288 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 289 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 290 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 291 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 292 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 293 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 294 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 295 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 296 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 297 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 298 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 299 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 300 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 301 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 302 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 303 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 304 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 305 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 306 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 307 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 308 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 309 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 310 "/home/saranya/Dokument/ktc/bin/../include/cilktc.h"
# 4 "log.h"
extern void log_trace_init(char const *func , struct _IO_FILE *fp ) ;
# 5 "log.h"
extern void log_trace_init_tp(struct _IO_FILE *fp , int tp , long *arrival_init , struct timespec itime ) ;
# 6 "log.h"
extern void log_trace_arrival(FILE *fp , int tp , int interval , int res , long *last_arrival ) ;
# 7 "log.h"
extern void log_trace_release(FILE *fp , long last_arrival , struct timespec itime , struct timespec *stime , int interval ) ;
# 8 "log.h"
extern void log_trace_execution(FILE *fp , struct timespec stime ) ;
# 9 "log.h"
extern void log_trace_end_id(FILE *fp , int id , struct timespec stime ) ;
# 10 "log.h"
extern void log_trace_abort_time(FILE *fp , long last_arrival , struct timespec stime , int interval , int id ) ;
# 12 "test1.c"
extern void mrad2deg(int k ) ;
# 16 "test1.c"
FILE dfile ;
# 22 "test1.c"
extern int ( sdelay)() ;
# 18 "test1.c"
void * __attribute__((__task__)) tsk_foo(void)
{
  int i ;

  {
# 20 "test1.c"
  i = 0;
# 20 "test1.c"
  while (i < 50) {
# 21 "test1.c"
    mrad2deg(50);
# 22 "test1.c"
    sdelay(30, 30, -3);
# 20 "test1.c"
    i ++;
  }
# 24 "test1.c"
  return ((void * )0);
}
}
# 31 "test1.c"
extern int ( basicmath_small)() ;
# 27 "test1.c"
void * __attribute__((__task__)) tsk_bar(void)
{
  int i ;

  {
# 30 "test1.c"
  i = 0;
# 30 "test1.c"
  while (i < 50) {
# 31 "test1.c"
    basicmath_small();
# 32 "test1.c"
    sdelay(20, 20, -3);
# 30 "test1.c"
    i ++;
  }
# 35 "test1.c"
  return ((void * )0);
}
}
# 41 "test1.c"
extern int ( rad2deg)() ;
# 38 "test1.c"
void * __attribute__((__task__)) tsk_far(void)
{
  int i ;

  {
# 40 "test1.c"
  i = 0;
# 40 "test1.c"
  while (i < 50) {
# 41 "test1.c"
    rad2deg(100);
# 42 "test1.c"
    sdelay(60, 60, -3);
# 40 "test1.c"
    i ++;
  }
# 44 "test1.c"
  return ((void * )0);
}
}
# 48 "test1.c"
int *dummyglobalvariable ;
# 48 "test1.c"
int populatelist(int num )
{


  {
# 48 "test1.c"
  if (num == 0) {
# 48 "test1.c"
    return (0);
  }
# 48 "test1.c"
  qsort(list_dl, num, sizeof(int ), & compare_qsort);
# 48 "test1.c"
  qsort(list_pr, num, sizeof(int ), & compare_qsort);
# 48 "test1.c"
  return (1);
}
}
# 48 "test1.c"
void main(void)
{
  unsigned long targ ;

  {
# 49 "test1.c"
  targ = 10;
# 50 "test1.c"
  tsk_foo();
# 51 "test1.c"
  tsk_bar();
# 52 "test1.c"
  tsk_far();
# 53 "test1.c"
  printf("main--end\n");
# 54 "test1.c"
  return;
}
}
