# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables to make the installation non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install OpenSSH server
RUN apt-get update && \
    apt-get install -y openssh-server python3 bzip2 cron xxd gcc git nfs-common nfs-kernel-server netcat-traditionnal && \
    apt-get clean

# Alias python to python3
RUN ln -s /usr/bin/python3 /usr/bin/python & \
    ln -s /usr/bin/pip3 /usr/bin/pip

# Create the SSH directory and set the root password
RUN mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd

# Allow root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise, the user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Expose port 22
EXPOSE 22

# Copy the "data" and "scripts" directories and the "install.sh" file to the container
COPY data /data
COPY scripts /scripts
COPY install.sh /install.sh
COPY motd.txt /motd.txt

# Avoid an error with the motd
RUN echo> /etc/legal
RUN chmod -x /etc/update-motd.d/*


# Make sure the install.sh script is executable
RUN chmod +x /install.sh

# Install the levels
RUN ./install.sh

# Start the SSH service
CMD ["/usr/sbin/sshd", "-D"]