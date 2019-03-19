
#include <time.h>

void log_trace_init(const char* func, struct _IO_FILE *fp);
void log_trace_init_tp(struct _IO_FILE *fp, int tp, long* arrival_init, struct timespec itime);
void log_trace_arrival(FILE* fp, int tp, int interval, int res, long *last_arrival);
void log_trace_release(FILE* fp, long last_arrival, struct timespec itime, struct timespec* stime, int interval);
void log_trace_execution(FILE* fp, struct timespec stime);
void log_trace_end_id(FILE* fp, int id, struct timespec stime);
void log_trace_abort_time(FILE* fp);
