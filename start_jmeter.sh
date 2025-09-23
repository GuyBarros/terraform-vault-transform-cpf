JVM_ARGS="-Xms1024m -Xmx1024m" jmeter -n -t api_test_case.jmx

-s -Jserver.rmi.ssl.disable=true