FROM busybox

COPY package/channel/channel.json /channel.json

ENTRYPOINT [ "busybox", "cp" ]
CMD [ "/channel.json", "/data/output" ]
