Steps to reproduce
------------------

SETUP: the Dockerfile will copy the file `authorized_keys` (in the same directory where Dockerfile is) to the container, to allow login using ssh. If you
don't create a `authorized_keys`, Docker won't be able to create the image.

To reproduce the bug and check the status of supervisord you will need to open 3 terminals.

In the first console, build the docker image and launch the container

    $ ./build.sh
    $ ./launch-docker.sh 
    2014-07-30 23:14:27,061 CRIT Supervisor running as root (no user in config file)
    2014-07-30 23:14:27,103 INFO /var/tmp/supervisor.sock:Medusa (V1.1.1.1) started at Wed Jul 30 23:14:27 2014
    	Hostname: <unix domain socket>
    	Port:/var/tmp/supervisor.sock
    2014-07-30 23:14:27,184 CRIT Running without any HTTP authentication checking
    2014-07-30 23:14:27,185 INFO supervisord started with pid 1
    2014-07-30 23:14:27,188 INFO spawned: 'nginx' with pid 10
    2014-07-30 23:14:27,191 INFO spawned: 'sshd' with pid 11

![Screenshot](https://raw.githubusercontent.com/hgdeoro/test-supervisord/master/screenshot01.png)


In the sencond console, login and check the supervisor status (this works fine)

    $ ssh -p 20022 user@localhost
    $ sudo -i
    $ supervisorctl status
    nginx          RUNNING    pid 10, uptime 0:01:13
    sshd           RUNNING    pid 11, uptime 0:01:13
    $

![Screenshot](https://raw.githubusercontent.com/hgdeoro/test-supervisord/master/screenshot02.png)

Now, in the same console, try to stop nginx:

    $ supervisorctl stop nginx

![Screenshot](https://raw.githubusercontent.com/hgdeoro/test-supervisord/master/screenshot03.png)


You can see that nginx was stopped:

![Screenshot](https://raw.githubusercontent.com/hgdeoro/test-supervisord/master/screenshot04.png)

The previous command never returns the control back to the shell.

You can confirm that the `supervisorctl stop nginx` command worked: in the thirth console, enter the docker image and check the status:

    $ ssh -p 20022 user@localhost
    $ sudo -i
    $ supervisorctl status
    nginx          STOPPED    Jul 30 11:17 PM
    sshd           RUNNING    pid 11, uptime 0:04:18
    $

![Screenshot](https://raw.githubusercontent.com/hgdeoro/test-supervisord/master/screenshot05.png)


