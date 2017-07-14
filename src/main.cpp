#include <iostream>
#include <fstream>
#include <cstdlib>
#include "binlog.h"
using namespace std;

int magic_number = 0;
unsigned int filelen = 0;
int main(int argc, char **argv) {
	if(argc < 2) exit(1);

	ifstream in(argv[1]);
	if(! in.is_open()) cout<<"Error open file"<<endl,exit(1);
	
	in.seekg(0, ios::end);
	filelen = in.tellg();
	in.seekg(0, ios::beg);

	in.read((char *)&magic_number, 4);
	cout<<hex<<magic_number<<endl;
	while(! in.eof()) {
		BinlogEventHeader event_header = {0};
		in.read((char *)&event_header, 19);
		cout<<"==binlog event=="<<endl;
		cout<<"timestamp:"<<dec<<event_header.timestamp<<endl;
		cout<<"type_code:"<<dec<<(int)event_header.type_code<<endl;
		cout<<"server_id:"<<dec<<event_header.server_id<<endl;
		cout<<"event_length:"<<dec<<event_header.event_length<<endl;
		cout<<"next_position:"<<dec<<event_header.next_position<<endl;
		cout<<"flags:"<<dec<<event_header.flags<<endl;
		if(event_header.next_position >= filelen) exit(1);
		in.seekg(event_header.next_position, ios::beg);
	}
	return 0;
}
