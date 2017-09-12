<?php
print <<<END
<p>
<h1>Docker Starter</h1>

Welcome, you've docker running and found the url to this project.
<ul>
<li>For your new project, copy this one or create a new one under projects with a webroot directory.</li>
<li>Like: projects/yourproject/webroot</li>
<li>Then you can reach it by http://yourproject:8001</li>
</ul>

For Xdebug 192.168.99.100with phpstorm you need an ssh connection to the container. You can start it up with:
<ul>
<li>loggin to the container: docker exec -it exercises_web_1 /bin/bash</li>
<li>start the ssh: /usr/sbin/sshd</li>
</ul>

For more info see the README.md
http://web:8001/ 
</p>
END;

$daysInWeek = 7 ;
$daysInYear = 365 ;
$weeksInYear = $daysInYear/$daysInWeek ;
$result = $weeksInYear ;

echo "SERVER['REMOTE_ADDR'] " . $_SERVER['REMOTE_ADDR'];

echo phpinfo();

