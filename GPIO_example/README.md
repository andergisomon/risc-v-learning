# GPIO examples

This code demonstrates interfacing with the ESP32-C3. I heavily rely on the ESP32-C3 Technical Reference Manual by Espressif which you can find from their website.

I also thank [Warren Gay](https://github.com/ve3wwg) for his book _RISC-V Assembly Language Programming Using the ESP32-C3 and QEMU_ which gave me a solid headstart.

For debugging purposes you can wrap your main assembly routine in a .c file so you can call your assembly routine in the app_main() function, or you can call printf in your assembly file. You can simply just have your code consist of a .S file in which case, update ```CMakeLists.txt``` however you need to rename your assembly routine to ```app_main``` since this is the application loop when using the ESP-IDF framework.
