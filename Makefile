build:
			docker build -t hi .

runon:
			docker run -it --rm -e INDEX=on -p 80:80 -p 443:443 hi

runoff:
			docker run -it --rm -e INDEX=off -p 80:80 -p 443:443 hi

kill:
			-docker kill 'docker ps -qa'


iclean: kill
			-docker rmi 'docker images -q'


# cclean: Removes all the containers
# "-q" option is used to provide each container's unique ID
# If there are no containers, calling this Makefile rule will give an error
cclean: kill
			-docker rm 'docker ps -qa'


# prune: Cleans up temporary files and other leftovers in memory
prune:
			docker system prune
