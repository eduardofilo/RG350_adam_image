# Create .tgz

```
DIRECTORY=$(pwd)
cd ${DIRECTORY}
tar --directory=${DIRECTORY}/root/ -czvf Sideload.tgz media
```

# Check permissions

```
tar -tvf Sideload.tgz
```
