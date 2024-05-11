#include "sqlcarto.h"
#include "bytea2cstring.h"
#include <curl/curl.h>

PG_MODULE_MAGIC;

//
struct upload_status
{
    size_t bytes_read;
};

static size_t payload_source(char *ptr, size_t size, size_t nmemb, void *userp)
{
    struct upload_status *upload_ctx = (struct upload_status *)userp;
    const char *data;
    size_t room = size * nmemb;

    if ((size == 0) || (nmemb == 0) || ((size * nmemb) < 1))
    {
        return 0;
    }

    // data = &payload_text[upload_ctx->bytes_read];

    if (data)
    {
        size_t len = strlen(data);
        if (room < len)
            len = room;
        memcpy(ptr, data, len);
        upload_ctx->bytes_read += len;

        return len;
    }

    return 0;
}

PG_FUNCTION_INFO_V1(sc_send_mail); // 发送邮件

Datum sc_send_mail(PG_FUNCTION_ARGS)
{
    char *errormessage = NULL;
    bool sendok = false;

    // 获取参数
    char *sender = bytea_to_cstring(PG_GETARG_BYTEA_P(0));
    char *reciever = bytea_to_cstring(PG_GETARG_BYTEA_P(1));
    char *subject = bytea_to_cstring(PG_GETARG_BYTEA_P(2));
    char *content = bytea_to_cstring(PG_GETARG_BYTEA_P(3));
    char *smtp = bytea_to_cstring(PG_GETARG_BYTEA_P(4));
    char *password = bytea_to_cstring(PG_GETARG_BYTEA_P(5));
    CURL *curl;
    CURLcode res = CURLE_OK;
    struct curl_slist *recipients = NULL;
    struct upload_status upload_ctx = {0};

    curl = curl_easy_init();
    if (curl)
    {
        curl_easy_setopt(curl, CURLOPT_USERNAME, sender);
        curl_easy_setopt(curl, CURLOPT_PASSWORD, password);
        curl_easy_setopt(curl, CURLOPT_URL, smtp);
        curl_easy_setopt(curl, CURLOPT_MAIL_FROM, sender);
        recipients = curl_slist_append(recipients, reciever);
        curl_easy_setopt(curl, CURLOPT_MAIL_RCPT, recipients);
        curl_easy_setopt(curl, CURLOPT_READFUNCTION, payload_source);
        curl_easy_setopt(curl, CURLOPT_READDATA, &upload_ctx);
        curl_easy_setopt(curl, CURLOPT_UPLOAD, 1L);
        curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);
        res = curl_easy_perform(curl);
        if (res != CURLE_OK)
        {
            errormessage = strdup(curl_easy_strerror(res));
            sendok = false;
        }
        else
        {
            errormessage = strdup("OK");
            sendok = true;
        }
        curl_slist_free_all(recipients);
        curl_easy_cleanup(curl);
    }
    else
    {
        errormessage = strdup("can not init curl");
        sendok = false;
    }

    free(sender);
    free(reciever);
    free(subject);
    free(content);
    free(smtp);
    free(password);

    if(!sendok){
        elog(NOTICE,"%s",errormessage);
        free(errormessage);
        PG_RETURN_BOOL(FALSE);
    }
    free(errormessage);
    PG_RETURN_BOOL(TRUE);
}
