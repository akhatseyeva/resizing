### Resizing

To resize an EBS volume, you have to provide the following steps:

1. Specify the end size of volume
2. Check Instance Name
3. Get VolumeID
4. Resize an EBS volume 
5. Check filesystem type
6. Rewrite the partition table
7. Extend the filesystem


### To execute the CLI, you need to download,grant execution rights, then run the script:

chmod +x script.sh

./script.sh <size>
  
Final result:
 
![log ](https://github.com/akhatseyeva/resizing/blob/ef604eb26ac06550fda0aaf428dcbf3a24550d9a/result.jpg)

  

  
 

