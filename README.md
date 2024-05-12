# Build Docker container from Dockerfile

Welcome to the Dockerfile Basics with Python exercises! These exercises are designed to reinforce your knowledge of Docker, focusing on Dockerfiles, building containers, and managing containerized applications. Let’s dive into the world of Docker and make the concepts 'click' through hands-on practice.

## _What you will learn_

- **Understanding Dockerfile Structure:** Learn how to structure your project and Dockerfile for efficient container builds.
- **Docker Commands**: Get hands-on experience with essential Docker commands for building, running, and managing containers.
- **Deeper Insight into Dockerfile Commands**: Understand the purpose and use of specific Dockerfile commands like **WORKDIR**, **ENTRYPOINT**, and **CMD**, and how they affect your container's behavior.

## Prerequisites
Before you start, make sure you have the following installed:

- Docker
- git

## Setup
Clone this repository to your local machine to get started:
```sh
git clone git@github.com:cloudprogrammers/dockerfile-basics-python.git
cd dockerfile-basics-python
```
Or just download .zip package with code.

# EXERCISES

## Exercise 1: Project Structure and Docker Build

**Objective**
Understand the project structure required for building a Docker image and practice building an image.
Learn how to run a Docker container in detached mode and how to view its logs.

**Tasks**


**1. Examine the Project Structure:** Notice how the Dockerfile is placed at the root of the project directory. This is the standard placement to inform Docker where to start the build process.

**2. Build the Docker Image:** Inside the **dockerfile-basics-python/** directory, build the Docker image and tag it as python-demo:
```
docker build -t python-demo .
```
You should now have a Docker image tagged as **python-demo**. Verify by running:
```
docker images | grep python-demo
```
**3. Run the built image:** :
```
docker run -d --name python-container python-demo
```
**Outcome**
Examine the container logs by running:
```
docker logs python-container
```
You should have logs from the python script running and producing default output. 

## Exercise 2: Adding arguments to container process with CMD

**Objective**
Learn how to run a Docker container in detached mode and how to view its logs.

**Tasks**
**1. Add the CMD in the last line of Dockerfile:**
```
... #previous steps
CMD ["--name", "<your name>"] #replace 
```
**2. Rebuild the container:** We modified the Dockerfile itself, so for changes to take effect, we need to re-build the container. While still inside **dockerfile-basics-python/** directory 
```
docker build --no-cache -t python-demo .
```
**3. Stop the previous container:** We want to run the container from the newly built, modified image. So that let's get rid of the previous version, which is still running:
```
docker stop python-container
```
as we named the container **python-container** in previous step. 

**3. Run the Container in Detached Mode:** 
```
docker run -d --name python-container python-demo
```
And verify the logs.
**Outcome**
Understand that the **CMD** provides default arguments to the **ENTRYPOINT**, and in this case, passes --name <your-name> to the Python script.

## Exercise 3: Understanding WORKDIR

**Objective**
Gain a deeper understanding of the **WORKDIR** command in Dockerfiles.

**Task**
Notice how **WORKDIR /usr/src/app** is used in the Dockerfile before copying files and running commands. This sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, and ADD instructions that follow.
Realize that after the **WORKDIR** command, all relative paths in the Dockerfile commands are based on /usr/src/app inside the container.
When you exec (get into) running container, like:
```
docker exec -it python-container /bin/sh
```
And type in 
```
pwd
```
in the container, you realize you are in the directory marked by **WORKDIR** - /usr/src/app

## Exercise 4: Reading from a File

**Objective**
Learn how to move files between your machine and Docker container. Use **COPY** and practice using volumes.

**Tasks**

**1. Modify the CMD in the last line of Dockerfile:**
```
... #previous steps
CMD ["--filename", "catalog/message.txt"]
```
**2. Rebuild the container:** We modified the Dockerfile itself, so for changes to take effect, we need to re-build the container. While still inside **dockerfile-basics-python/** directory 
```
docker build --no-cache -t python-demo .
```
**3. Stop the previous container:** We want to run the container from the newly built, modified image. So that let's get rid of the previous version, which is still running:
```
docker stop python-container
```
as we named the container **python-container** in previous step. 

**3. Run the Container in Detached Mode:** 
```
docker run -d --name python-container python-demo
```
And verify the logs. You should see the python application screaming at you that it cannot find the file specified in **CMD** command.

> The script is looking for the file message.txt in catalog/ directory. However, this catalog does not exist.
> See it yourself, by getting into running container:
```
docker exec -it python-container /bin/sh
```
> and run
```
ls -al
```
> as you see, there is no catalog/ directory, just two python files. __init__.py and main.py.
>main.py is our application.

In your local environment, in **dockerfile-basics-python/** directory, there is a sub-directory called **catalog/**, where you can find the message.txt file that the container is looking for. 
Now, we need a way to deliver this file to the container, so that it can make use of it. 
To do it, we can take two approaches. 

**4. Fix it with COPY:** 
First, we can copy the file directly into the container on the build stage.
Try it. Add the appropriate COPY command into your Dockerfile
```
COPY catalog/ ./catalog
```
Which copies the whole **catalog/** directory from the directory that Dockerfile is in, to the **WORKDIR**
The dot (.) represents current working directory, which was set to /usr/src/app and new /catalog directory.

**Rebuild and re-run the container** After doing this, you should have the whole catalog inside the container. 
Exec the container and verify the catalog is there. Run docker logs to see if the application now has necessary files.

**5. Fix it with VOLUMES:** 

Secondly, we can supply the file to the container by mounting the volume from our machine to the container.
First remove the **COPY** instruction
```
COPY catalog/ ./catalog
```

**Rebuild the container:**  Do it as previously with
```
docker build -t python-demo .
```

**Attach the directory with file to the container:**

Now, after we stopped the previously running container, we can run it once again, but with the **catalog/** directory attached (shared) with container via volume. 
The default command:

```
docker run -d --name python-container -v $(pwd)/catalog:/usr/src/app/catalog python-demo
```
will run read-only volume. Meaning that the container can only read the contents of the shared catalog, but cannot modify it. 
Alternatively, if we want to modify the files on our machine, we can change the volume to read-write.

```
docker run -d --name python-container -v $(pwd)/catalog:/usr/src/app/catalog:rw python-demo
```

**Check the effect:**
Now, log into running container via docker-exec. Check if the directory appears inside container.
Try to modify the message.txt inside container in read-only mode. Repeat with read-write mode.
Check the logs.

**Outcome**

Observe how the logs change when the file is added via a **COPY** command in the Dockerfile versus mounted from the host. In both cases, the script should successfully read and print the contents of message.txt.

## Exercise 5: Website Monitoring and Notifications
**Objective**
You have been tasked to set up a website for a client who demands high reliability and wants to be notified immediately if their website becomes unreachable. The solution will use NGINX as the web server because of its efficiency and popularity for serving web content and handling reverse proxy tasks.

**Before you proceed**
Create new directory on your computer for this exercise. 
Name it `docker_website_monitoring` for example.
Inside this directory, initialize empty git repository:

```
git init
```

As by the end of this exercise you will be asked to submit it for review.

The system will consist of three main components:
**1. NGINX Container** Serves the website and handles web requests on port 80
**2. Mailer Container** Sends an email alert if the website goes down
**3. Watcher Container** Monitors the NGINX server and communicates with the Mailer if a downtime is detected.

This exercise will walk you through setting up each of these components in separate Docker containers, configuring them to work together and testing their functionality.

**TASK 1: Email Service Setup**
As we will need 3 parts to make this system up, let's start with the service that will be responsible for sending notifiaction emails. 

1. **SMTP Relay Service**
In our exercise, rather than setting up and managing a full SMTP server ourselves, we will configure a "relay" service using a Docker container. This relay service will act as an intermediary, receiving emails generated by our applications and passing them on to a more robust SMTP server managed by SendGrid. This approach simplifies configuration and avoids the complexities of directly managing mail delivery, security settings, and compliance with email sending policies.
>Why Use SendGrid?

SendGrid specializes in managing the delivery of emails on behalf of companies, ensuring high deliverability rates and compliance with the latest email standards. This includes handling:

**Anti-Spam Policies:** SendGrid ensures that emails do not violate spam regulations, which can lead to emails being blocked or sent to the spam folder. They manage sender reputations, which is crucial for maintaining good deliverability.
**Security Measures:** SendGrid supports email encryption in transit using TLS, adding a layer of security that protects the data integrity and privacy of email content.
**Rate Limiting and Feedback Loops:** They manage the rate at which emails are sent to avoid overloading recipients’ servers, which can also lead to blacklisting. Feedback loops with major email providers help to identify issues with sent emails, such as high bounce rates or spam complaints.

By setting up a relay with SendGrid inside a Docker container, we abstract the complexities of direct mail server management while leveraging SendGrid’s robust infrastructure to handle important aspects of email delivery. This setup not only ensures reliability and compliance with mailing standards but also aligns with DevOps practices by focusing on automation and scalability.

**SETUP**
**Create a SendGrid Account**: 
 - Visit SendGrid's [Website](https://sendgrid.com/en-us) and sign up for a new account.
 - Follow the on-screen instructions to complete the account setup, including email verification.
**Setup Single Sender Verification Auth**
 - Go to [Single Sender Verification](https://app.sendgrid.com/settings/sender_auth) section in your SendGrid Account and set up an email that will be used as a verified "FROM" email address.
**Generate an API Key**
 - Navigate to the API Keys section under Settings in your SendGrid dashboard.
 - Click "Create API Key". Choose a name for your key and select "Full Access" for the permissions.
 - Copy the API key provided. This will be used later in the Docker configuration.

For detailed instruction, please check [integration guide](https://app.sendgrid.com/guide/integrate)

2. **Run the container with mailer service**
Inside the directory, where you are running your project, 
```
docker run -d --name mailer -p "587:587" \
    -e SMTP_SERVER=smtp.sendgrid.net \
    -e SMTP_PORT=587 \
    -e SMTP_USERNAME=apikey \
    -e SMTP_PASSWORD=your_sendgrid_api_key \
    -e OVERWRITE_FROM=office@cloudprogrammers.pl \
    -e SERVER_HOSTNAME=cloudprogrammers.pl \
    juanluisbaptiste/postfix
```

Here, you need to substitute several environment variables so that everything runs smoothly. 


**SMTP_PASSWORD** - it's your Sendgrid API Key
**OVERWRITE_FROM** - it's the verified sender you have set up in the previous step. This will probably be your email address at this point.
**SERVER_HOSTNAME** - It's **host** part of your service domain. 

We use `juanluisbaptiste/postfix` base image to run the container with our mailer service inside.
You can read about this service [here](https://github.com/juanluisbaptiste/docker-postfix). 
The image itself is hosted in [DockerHub](https://hub.docker.com/r/juanluisbaptiste/postfix) image repository, which you will learn about later.

3. **Test the email service**
 - To verify that the service is running properly, first, access the running container (it means we log inside the running container)
```
docker exec -it mailer /bin/bash
```
 - then, when you are inside the container, send the mail using `sendmail`:
```
echo "Subject: Test Mail" | sendmail -f <from mail> -v recipient@example.com
```
just substitute `<from mail>` with the SendGrid Verfied Sender and `recipient@example.com` with the email you want to receive notification to. 
You can try [10 minute email](https://10minutemail.com/) for testing.

4. **Verify, if you recievied email.**  
5. **YOUR TURN**: Now, when you have the container up and running, stop and remove it. (You can use `docker ps` to list running containers and then `docker stop <container_id>` and `docker container rm <container_id>` to get rid of the container completely.)

When you no longer have mailer container, then create `mailer_service` directory inside your project catalog and create new `Dockerfile` inside. 

Your job is to put the logic necessary to run mailer service inside this Dockerfile. Use `juanluisbaptiste/postfix` as the base image and make it run the same as before. Good luck! 

**TASK 2: Nginx setup**
The main part we need is our website. We will be using nginx as a web server and ask it to serve the website each time someone visits our domain. As we are still in development phase, the nginx will be pointing to our local machine, `localhost`, as you remember from the [previous exercise](https://github.com/cloudprogrammers/01_package_management_ec2_hometask_4?tab=readme-ov-file#exercise-4-installing-nginx), where we were installing nginx. Go back to that section to refresh your knowledge about nginx.


1. Inside this repository, you can find a file named `index.html`. This is the first version of the website we will be managing. 
Create new directory, called `nginx_service` inside your project catalog. Copy this file to this catalog. 
2. For `nginx` service to run properly, we need configuration file, which we will be passing to the service container that we are building. Here is the skeleton of the configuration file:

```
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;
    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    root ___;  # Fill in the correct document root
    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        ___  # Fill in the correct directive to serve our index.html file
    }
}
```

As you see above, your task is to fill this configuration, where you have comment marks `#`
You need to do two things - specify document root, which is directory where nginx will be looking for files to serve and fill `location /` block, which instructs nginx what to do, when the user sends request to nginx root location (it's `http://localhost/`)

3. The next piece is the `Dockerfile` itself, which is the blueprint for nginx service. 
In the `nginx_service/` directory, create `Dockerfile`. Below is a template that requires work from your side.

```
# we start from ubuntu base image and install nginx manually. We could skip that and use for example nginx:latest which have nginx already installed. However we want to learn here.
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*  

# Create directory for SSL certificate
RUN mkdir -p /etc/nginx/ssl

# Generate SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=PL/ST=pomorskie/L=Sopot/O=CloudProgrammers/CN=www.cloudprogrammers.pl"

# Copy custom Nginx config from host to container
COPY ___ ___  # Provide correct source and destination

# Set the working directory to Nginx's web root
___ ___

# Inform Docker that the container listens on port 80 and 443
___ ___

# Use ENTRYPOINT to start Nginx in the foreground
___ ___ 
```
Just as before, your job now is to make Dockerfile working. Fill all the `___ ___ ` places with working code. 

4. **Test if the service is working**

First, build and tag (assign name) the image. To do it, navigate to the directory, where Dockerfile is, and issue command 

```
docker build -t nginx_service .
```

After above command passes succesfuly, we can verify that image has been built by listing all the images:

```
docker images
```
When we find our image on the list, it's time to launch the container from the image we have built. 
```
docker run -d --rm -p 80:80 -p 443:443 nginx_service
```

As a reminder, we `run` the container with `-d`, meaning in `detached` mode. We will not see any container logs or any output from it, as `detached` means it is running in the background.
Another flag, `--rm`, means automatically remove the container when it exits. This flag is used to clean up after the container, so you don't have leftover stopped containers taking up space.

## TASK 4: Integrating Watcher Feature into Mailer Service
**Overview**:
The watcher service is a crucial component that ensures the availability of the Nginx server by periodically checking its status. If the server fails to respond, the watcher triggers an alert by sending an email through the previously set up mailer service.
However, we will simplyfy our approach and we will not create separate container for watcher service at this point. 
The mailer service is responsible only for sending emails, so for the sake of simplicity, we will perform nginx monitoring directly inside mailer service. 


1. **Build the Watcher Service**
**Description:** Use a simple script or a lightweight monitoring tool within a mailer Docker container to periodically check the health of the Nginx server.
2. **Steps**: 
 - Create a bash script `healthcheck.sh` that uses curl to check the HTTP status code from the Nginx server.
 ```
 #!/bin/bash

while true; do
  response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)
  if [ "$response" -ne 200 ]; then
    echo "Subject: Nginx Server Down" | sendmail -v your-email@example.com
    echo "Nginx server down, alert sent" >> /var/log/nginx_watcher.log
  else
    echo "Nginx server is running smoothly" >> /var/log/nginx_watcher.log
  fi
  sleep 30
done
 ```
 - Create Dockerfile
 - Build Dockerfile with mailer and watcher combined into one service. `cd` into `mailer_service` (you can rename it into `watcher_service`) and run:
 ```
 docker build -t mailer-service \
  --build-arg SMTP_USERNAME=your_username \
  --build-arg SMTP_PASSWORD=your_password \
  --build-arg OVERWRITE_FROM=your_email@example.com \
  -f Dockerfile .
 ```

Remeber to substitute the values to proper username, your SendGrid API key and email.

```
docker run -d --name mailer -p "587:587" mailer-service
```

# Key Points to Remember

**Dockerfile Location:** Always place your Dockerfile at the root of your project directory to signal the start of the build context to Docker.

**Container Lifecycle Management:** Familiarize yourself with the lifecycle of a Docker container — from building an image with docker build to running it with docker run and finally stopping it with docker stop.

**WORKDIR Importance:** **WORKDIR** sets the working directory for any **RUN**, **CMD**, **ENTRYPOINT**, **COPY**, and **ADD** instructions that follow in the Dockerfile, influencing where commands are executed and where files are placed.

**Combining ENTRYPOINT and CMD:** **ENTRYPOINT** specifies a command that will always be executed when the container starts, and **CMD** provides default arguments that can be overridden by command-line arguments when the container starts.


# Commands Used

| Command | Description |
| ------ | ------ |
| docker build -t python-demo . | Builds the Docker image from the Dockerfile in the current directory and tags it as python-demo |
| docker run --rm -d --name python-container python-demo | Runs the python-demo image in detached mode with the container named python-container. |
| docker logs python-container | Displays the logs of the container named python-container |
| docker stop python-app | Stops the running container named python-container |
| docker run --rm -d -v $(pwd)/catalog/:/usr/src/app/catalog/ python-demo | Runs the python-demo image in detached mode, mounting the catalog/ directory from the host to /usr/src/app/catalog inside the container |
