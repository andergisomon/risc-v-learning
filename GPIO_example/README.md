# GPIO examples

This code demonstrates interfacing with the ESP32-C3. I heavily rely on the ESP32-C3 Technical Reference Manual by Espressif which you can find from their website.

I also thank [Warren Gay](https://github.com/ve3wwg) for his book _RISC-V Assembly Language Programming Using the ESP32-C3 and QEMU_ which gave me a solid headstart.

Since you can't really have a project entirely in assembly, you need to wrap your main assembly routine in a .c file whose sole job is to call your assembly routine in its own app_main() function.
