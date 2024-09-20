PR:append = "_edgeai_0"

ARM_EDGEAI_STACK = " \
    ti-tidl-osrt-dev \
    ti-tidl-osrt-staticdev \
    edgeai-gst-apps \
    edgeai-studio-agent \
    edgeai-gst-plugins-dev \
    edgeai-dl-inferer-staticdev \
    edgeai-gst-apps-source \
    edgeai-gst-plugins-source \
    edgeai-apps-utils-source \
    edgeai-dl-inferer-source \
    edgeai-tidl-models \
    edgeai-test-data \
"

# Add EdgeAI Components for ARM only analytics
#IMAGE_INSTALL:append:am62xx = " \
#    ${ARM_EDGEAI_STACK} \
#"
