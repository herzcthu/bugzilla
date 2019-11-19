# Bugzilla 
This is bugzilla installation in docker. Based apache2 2.4.

# Instructions
To start container and go into shell
```
docker-compose up -d
docker-compose exec bugzilla bash
```

To initialize bugzilla, in docker container shell

```
cd htdocs
./checksetup.pl
```
