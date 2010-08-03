HBase Explorer
==============

A Hue based HBase Explorer.

It allows you to browse any number of remote HBase clusters. For each cluster you can get details about its version,
the cluster status and existing tables. 

Screen shot:
.. image:: http://github.com/larsgeorge/hbase-explorer/raw/master/src/hbexplorer/static/art/huescreen.png

Installation
------------

This section describes how to build, package and deploy the HBase Explorer application to an existing HUE setup.
 
TBD.

Testing
-------

For a quick setup of a test environment, simply download a HBase 0.20.5 tarball and unpack it. Then run::

    cd hbase-0.20.5/
    cp ./contrib/startgate/*.jar ./lib/
    cp ./contrib/startgate/lib/*.jar ./lib/
    ./bin/start-hbase.sh
    ./bin/hbase-daemon.sh start org.apache.hadoop.hbase.stargate.Main -p 8888
    ./bin/hbase shell
    
and use the shell to create a few tables to test with like so::

    hbase(main):001:0> create 't1', 'f1', 'f2', 'f3'
    hbase(main):002:0> create 't2', 'f1', 'f2', 'f3'
    
Once this is done and HBase and Stargate running then use "Add Cluster" on the first page of the HBase Explorer to 
add a "localhost:8888" to the list of known clusters. After that you can click on that address in the list and explore
to your hearts content.