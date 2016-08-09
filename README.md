# Continues Integration

This folder contains various scripts that together can be used as CI.
Just like Git, it is composed of all kinds of separate tools.
The scripts starting with a dot are hidden
and are dependencies that should not be ran by itself.

## How to
An example of the coding flow could be;

![alt text](gitflow.png "drawn with draw.io by svlentink")

of which the tests phase should be ran before committing.
The next picture shows what we intend to create with `gitTrigger.sh`:

![alt text](build.png "drawn with draw.io by svlentink")

The tests are ran,
after which the container is build/pulled/ran by `.launch.sh`.
This file should be changed according to the specific needs (e.g. docker-compose).

Then the reverse proxy (Nginx) config is changed to include the new appserver
that has just been added
(it is ran on the specify network and the next available port).
For more info about configuring this and weight distribution across appservers,
click [here](http://nginx.org/en/docs/http/load_balancing.html).
When the server runs and the config file is changed by `.addNewUpstreamNginx.sh`,
the reverse proxy is reloaded to include the new configuration.

After everything is up and running, the `server-status.sh` is executed.

### Nginx config
Nginx config files have the ability to include files.
This CI uses that technique and requires the admin to configure the
`upstream` section to be in a separate file.
All addition parameter (e.g. `least_conn`, `ip_hash`)
should be define right after the opening bracket
e.g. (`upstream randomapp { ip_hash;`).

For general info about Nginx and upstream, click
[here](http://nginx.org/en/docs/http/load_balancing.html).


## Files and scripts

### CI.conf
The config file that is loaded by the scripts.

You should not delete or overwrite an variable,
just declare it a second time, it will take the last one.

### js-tests.sh
This script is just a wrapper for [hub.docker.com/r/superbuddy/testnodejs](https://hub.docker.com/r/superbuddy/testnodejs)

### status-tests.sh
This script is just a wrapper for
[hub.docker.com/r/superbuddy/server-status](https://hub.docker.com/r/superbuddy/server-status)

### gitTrigger.sh
This script first runs `js-tests.sh`, followed by `status-tests.sh`.
If the code passes the tests and the current system is running correctly,
it proceeds to launching the new code, next to the previous online code (Nginx randomly addresses the server).
Git allows you to specify hooks in `REPO_DIR/.git/hooks`.
The post-receive should be symlinked (`ln -s`) to `gitTrigger.sh` (on the Git server).
The pre-commit should be linked to `js-tests.sh`.

For more info on hooks; [https://git-scm.com/docs/githooks](https://git-scm.com/docs/githooks)

For more info about session management in Nginx when running redundant appservers,
please look [here](http://nginx.org/en/docs/http/load_balancing.html#nginx_load_balancing_with_ip_hash)
and [here](https://www.nginx.com/products/session-persistence/).
