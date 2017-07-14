#ifndef __BINLOG_H__
#pragma pack()
typedef struct _BinlogEventHeader {
	int timestamp;
	unsigned char type_code;
	int server_id;
	int event_length;
	int next_position;
	short flags;
}BinlogEventHeader;

#endif
