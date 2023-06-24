
FROM althack/ros2:humble-dev

ENV ROS_DISTRO=humble
ENV AMENT_PREFIX_PATH=/opt/ros/humble
ENV COLCON_PREFIX_PATH=/opt/ros/humble
ENV LD_LIBRARY_PATH=/opt/ros/humble/lib
ENV PATH=/opt/ros/humble/bin:$PATH
ENV PYTHONPATH=/opt/ros/humble/lib/python3.8/site-packages
ENV ROS_PYTHON_VERSION=3
ENV ROS_VERSION=2

ENV DEBIAN_FRONTEND=dialog

# ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  # dev stuff
  bash-completion \
  build-essential \
  cmake \
  gdb \
  git \
  tig \
  vim \
  ranger \
  wget \
  gdbserver \
  htop \
  xterm \
  # pylint3 \
  python3-argcomplete \
  python3-colcon-common-extensions \
  python3-pip \
  python3-rosdep \
  python3-vcstool \
  # Install ros distro testing packages
  ros-humble-ament-lint \
  ros-humble-launch-testing \
  ros-humble-launch-testing-ament-cmake \
  ros-humble-launch-testing-ros \
  python3-autopep8 \
  && rm -rf /var/lib/apt/lists/* \
  && rosdep init || echo "rosdep already initialized"
  
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG USERNAME=ros
ARG WORKSPACE=/home/${USERNAME}

ENV HOME=/home/${USERNAME}
ENV WS=${WORKSPACE}

ARG CMAKE_BUILD_TYPE=RelWithDebInfo

# Install dotnet SDK
RUN apt-get update && \
    apt-get install -y dotnet-sdk-6.0 && \
    rm -rf /var/likb/apt/lists/*

ENV DEBIAN_FRONTEND=dialog

# Create workspace folder
WORKDIR $WS
RUN mkdir ws

# Install ros dependencies
COPY --chown=$USERNAME . ws

RUN apt-get update && \
    . /opt/ros/humble/setup.sh && \
    rosdep update && \
    rosdep install --from-paths ws/src --ignore-src -y && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y ros-${ROS_DISTRO}-test-msgs && \
    apt install -y ros-${ROS_DISTRO}-fastrtps ros-${ROS_DISTRO}-rmw-fastrtps-cpp && \
    apt install -y ros-${ROS_DISTRO}-cyclonedds ros-${ROS_DISTRO}-rmw-cyclonedds-cpp && \
    rm -rf /var/likb/apt/lists/*

USER $USERNAME

RUN sudo chown -R ros:ros /home/ros

RUN echo "if [ -f /home/ros/install/setup.bash ]; then source /home/ros/ws/install/setup.bash; fi" >> /home/ros/.bashrc
RUN echo "export RCUTILS_COLORIZED_OUTPUT=1" >> /home/ros/.bashrc

