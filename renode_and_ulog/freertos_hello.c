/*
 * Copyright (c) 2015, Freescale Semiconductor, Inc.
 * Copyright 2016-2017 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

/* FreeRTOS kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "timers.h"

/* Freescale includes. */
#include "fsl_device_registers.h"
#include "fsl_debug_console.h"
#include "board.h"
#include "app.h"

#include "ulog.h"

/*******************************************************************************
 * Definitions
 ******************************************************************************/
/* Task priorities. */
#define hello_task_PRIORITY (configMAX_PRIORITIES - 1)
/*******************************************************************************
 * Prototypes
 ******************************************************************************/
static void hello_task(void *pvParameters);

/*******************************************************************************
 * Code
 ******************************************************************************/
void my_console_logger(ulog_level_t severity, char *msg) {
    PRINTF("logger [%s]: %s\r\n",
           ulog_level_name(severity),
           msg);
}

// Derived from:
// https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
// https://github.com/rdpoor/ulog/issues/14
#define ANSI_RST  "\x1B[0m"           // Reset to default
#define ANSI_BRF  "\x1B[91m"          // Bright red fg, default bg
#define ANSI_BYF  "\x1B[93m"          // Bright yellow fg, default bg
#define ANSI_BMF  "\x1B[95m"          // Bright magenta fg, default bg
#define ANSI_BCF  "\x1B[96m"          // Bright cyan fg, default bg
#define ANSI_BWF  "\x1B[97m"          // Bright white fg, default bg
#define ANSI_RBBF "\x1B[41m\x1B[30m"  // Black fg, red bg

void color_console_logger(ulog_level_t severity, char *msg) {
    switch (severity) {
        case ULOG_CRITICAL_LEVEL: {
            PRINTF("%s(%8u ms) [CRT]: %s%s\r\n",
                   ANSI_RBBF,
                   pdTICKS_TO_MS(xTaskGetTickCount()),
                   msg,
                   ANSI_RST);
            break;
        }
        case ULOG_ERROR_LEVEL: {
            PRINTF("%s(%8u ms) [ERR]: %s%s\r\n",
                   ANSI_BRF,
                   pdTICKS_TO_MS(xTaskGetTickCount()),
                   msg,
                   ANSI_RST);
            break;
        }
        case ULOG_WARNING_LEVEL: {
            PRINTF("%s(%8u ms) [WRN]: %s%s\r\n",
                   ANSI_BYF,
                   pdTICKS_TO_MS(xTaskGetTickCount()),
                   msg,
                   ANSI_RST);
            break;
        }
        case ULOG_INFO_LEVEL: {
            PRINTF("%s(%8u ms) [INF]: %s%s\r\n",
                   ANSI_BWF,
                   pdTICKS_TO_MS(xTaskGetTickCount()),
                   msg,
                   ANSI_RST);
            break;
        }
        case ULOG_DEBUG_LEVEL: {
            PRINTF("%s(%8u ms) [DBG]: %s%s\r\n",
                   ANSI_BMF,
                   pdTICKS_TO_MS(xTaskGetTickCount()),
                   msg,
                   ANSI_RST);
            break;
        }
        case ULOG_TRACE_LEVEL: {
            PRINTF("%s(%8u ms) [TRC]: %s%s\r\n",
                   ANSI_BCF,
                   pdTICKS_TO_MS(xTaskGetTickCount()),
                   msg,
                   ANSI_RST);
            break;
        }
        default: {
            break;
        }
    }
}

/*!
 * @brief Application entry point.
 */
int main(void)
{
    /* Init board hardware. */
    BOARD_InitHardware();
    ULOG_INIT();
    ULOG_SUBSCRIBE(color_console_logger, ULOG_TRACE_LEVEL);
    if (xTaskCreate(hello_task, "Hello_task", configMINIMAL_STACK_SIZE + 100, NULL, hello_task_PRIORITY, NULL) !=
        pdPASS)
    {
        PRINTF("Task creation failed!.\r\n");
        while (1)
            ;
    }
    vTaskStartScheduler();
    for (;;)
        ;
}

/*!
 * @brief Task responsible for printing of "Hello world." message.
 */
static void hello_task(void *pvParameters)
{
    TickType_t start_tick = xTaskGetTickCount();
    //for (int i = 0; i < 100; i++)
    //{
        ULOG_TRACE("%s@%u: This is a trace print",
                   __func__,
                   __LINE__);
        ULOG_DEBUG("%s@%u: This is a debug print",
                   __func__,
                   __LINE__);
        ULOG_INFO("%s@%u: This is an info print",
                   __func__,
                   __LINE__);
        ULOG_WARNING("%s@%u: This is a warning print",
                   __func__,
                   __LINE__);
        ULOG_ERROR("%s@%u: This is an error print",
                   __func__,
                   __LINE__);
        ULOG_CRITICAL("%s@%u: This is a critical print",
                      __func__,
                      __LINE__);
    //}
    TickType_t end_tick = xTaskGetTickCount();

    PRINTF("XXX SCC: Test took %u ms\r\n", pdTICKS_TO_MS(end_tick - start_tick));
    vTaskDelete(NULL);
}
