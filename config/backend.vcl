backend default {
	.host = "127.0.0.1";
	.port = "8080";
	# Apache MPM: max. clients 256
	.max_connections = 200;
}

#backend static {
#	.host = "127.0.0.1";
#	.port = "8081";
#	# nginx: max. threads 4 * 1024
#	.max_connections = 4000;
#}
