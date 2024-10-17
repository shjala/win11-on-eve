# Installing Windows 11 on EVE
How to :
1. You need [EVE](https://github.com/lf-edge/eve) 13.4.0 or higher.
2. Download [install.sh](install.sh), this installation script simulates the EVE envirnment as close as possible.
3. Download Windows 11 iso from Microsoft website, in the `install.sh` make sure `WINDOWS_ISO` point to the installation iso path.
4. The `install.sh` is configured to use VNC as display, have a VNC client handy to connect to localhost:5901.
5. Run `install.sh` and proceed with the Windows installation, the `install.sh` downloads the required UEFI (OVMF) firmware and VirtIO driver before laucnhing the VM.
6. When reaching the drive selection screen you will see an empty list : ![image](https://github.com/user-attachments/assets/db2c93d3-b2a1-4e09-abd7-25163b843f4f)
7. Click on "Load driver to access your hardware" and select virtio-win CD drive: ![image](https://github.com/user-attachments/assets/3c1c86e4-47b9-4d88-b675-87f174dc4972)
8. Go to the `visostor` folder : ![image](https://github.com/user-attachments/assets/9ba7356a-591d-4882-b843-0231d416ba07)
9. Under the `visostor` folder, selcet `w11\amd64` : ![image](https://github.com/user-attachments/assets/18b57332-22fa-4e68-b452-438c3200b3ec)
10. You should see the the driver is ready to be installed, click on Install : ![image](https://github.com/user-attachments/assets/b4eb19ed-694b-47ef-a52b-d3d462d97d15)
11. After install is finished, you should see the VirtIO block device is now selectable : ![image](https://github.com/user-attachments/assets/76ea8457-329c-480e-b86c-81a2f59c077b)
12. Don't finish yet, repeat the same process from 7 to 9 but this time install the `NetKVM\w11\amd64`.
13. Proceed with Windows installation as normal.





