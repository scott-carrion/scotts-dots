#ifndef ULOG_H
#define ULOG_H

typedef enum {
  ULOG_TRACE_LEVEL=100,
  ULOG_DEBUG_LEVEL,
  ULOG_INFO_LEVEL,
  ULOG_WARNING_LEVEL,
  ULOG_ERROR_LEVEL,
  ULOG_CRITICAL_LEVEL,
  ULOG_ALWAYS_LEVEL
} ulog_level_t;

extern ulog_level_t s_lowest_log_level;

// The following macros enable or disable uLog.  If `ULOG_ENABLED` is
// defined at compile time, a macro such as `ULOG_INFO(...)` expands
// into `ulog_message(ULOG_INFO_LEVEL, ...)`.  If `ULOG_ENABLED` is not
// defined, then the same macro expands into `do {} while(0)` and will
// not generate any code at all.
//
// There are two ways to enable uLog: you can uncomment the following
// line, or -- if it is commented out -- you can add -DULOG_ENABLED to
// your compiler switches.
#define ULOG_ENABLED

#ifdef ULOG_ENABLED
  #define ULOG_INIT() ulog_init()
  #define ULOG_SUBSCRIBE(a, b) ulog_subscribe(a, b)
  #define ULOG_UNSUBSCRIBE(a) ulog_unsubscribe(a)
  #define ULOG_LEVEL_NAME(a) ulog_level_name(a)
  #define ULOG(...) ulog_message(__VA_ARGS__)
  #define ULOG_TRACE(...) do { if (ULOG_TRACE_LEVEL >= s_lowest_log_level) { ulog_message(ULOG_TRACE_LEVEL, __VA_ARGS__); } } while(0)
  #define ULOG_DEBUG(...) do { if (ULOG_DEBUG_LEVEL >= s_lowest_log_level) { ulog_message(ULOG_DEBUG_LEVEL, __VA_ARGS__); } } while(0)
  #define ULOG_INFO(...) do { if (ULOG_INFO_LEVEL >= s_lowest_log_level) { ulog_message(ULOG_INFO_LEVEL, __VA_ARGS__); } } while(0)
  #define ULOG_WARNING(...) do { if (ULOG_WARNING_LEVEL >= s_lowest_log_level) { ulog_message(ULOG_WARNING_LEVEL, __VA_ARGS__); } } while(0)
  #define ULOG_ERROR(...) do { if (ULOG_ERROR_LEVEL >= s_lowest_log_level) { ulog_message(ULOG_ERROR_LEVEL, __VA_ARGS__); } } while(0)
  #define ULOG_CRITICAL(...) do { if (ULOG_CRITICAL_LEVEL >= s_lowest_log_level) { ulog_message(ULOG_CRITICAL_LEVEL, __VA_ARGS__); } } while(0)
  #define ULOG_ALWAYS(...) ulog_message(ULOG_ALWAYS_LEVEL, __VA_ARGS__)
#else
  // uLog vanishes when disabled at compile time...
  #define ULOG_INIT() do {} while(0)
  #define ULOG_SUBSCRIBE(a, b) do {} while(0)
  #define ULOG_UNSUBSCRIBE(a) do {} while(0)
  #define ULOG_LEVEL_NAME(a) do {} while(0)
  #define ULOG(s, f, ...) do {} while(0)
  #define ULOG_TRACE(f, ...) do {} while(0)
  #define ULOG_DEBUG(f, ...) do {} while(0)
  #define ULOG_INFO(f, ...) do {} while(0)
  #define ULOG_WARNING(f, ...) do {} while(0)
  #define ULOG_ERROR(f, ...) do {} while(0)
  #define ULOG_CRITICAL(f, ...) do {} while(0)
  #define ULOG_ALWAYS(f, ...) do {} while(0)
#endif

typedef enum {
  ULOG_ERR_NONE = 0,
  ULOG_ERR_SUBSCRIBERS_EXCEEDED,
  ULOG_ERR_NOT_SUBSCRIBED,
} ulog_err_t;

// define the maximum number of concurrent subscribers
#ifndef ULOG_MAX_SUBSCRIBERS
#define ULOG_MAX_SUBSCRIBERS 6
#endif
// maximum length of formatted log message
#ifndef ULOG_MAX_MESSAGE_LENGTH
#define ULOG_MAX_MESSAGE_LENGTH 120
#endif
/**
 * @brief: prototype for uLog subscribers.
 */
typedef void (*ulog_function_t)(ulog_level_t severity, char *msg);

void ulog_init(void);
ulog_err_t ulog_subscribe(ulog_function_t fn, ulog_level_t threshold);
ulog_err_t ulog_unsubscribe(ulog_function_t fn);
const char *ulog_level_name(ulog_level_t level);
void ulog_message(ulog_level_t severity, const char *fmt, ...);

#endif
