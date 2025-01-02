# Dockerfile
FROM debian:latest

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    nasm \
    gcc \
    clang \
    lldb \
    gdb \
    make \
    python3 \
    python3-pip \
    libc6-dev \
    binutils \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install guiGDB
# RUN pip install gdbgui

# Set up a working directory
WORKDIR /app

# Copy project files
COPY . .

# Default command
CMD ["/bin/bash"]
