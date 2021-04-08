# Fans

**Don't bother trying to improve fans - you only make it worse.**

But here are the notes&hellip;

For fans on XPS 15, follow https://medium.com/@kasunsiyambalapitiya/fixing-constantly-running-fans-on-dell-laptops-running-ubuntu-16-04-8cf6595381d9 with settings like:

~~~no-highlight
set config(0)   {{0 0}  -1  62  -1  62}
set config(1)   {{1 0}  53  72  53  72}
set config(2)   {{1 1}  58  77  58  77}
set config(3)   {{2 1}  63  82  63  82}
set config(4)   {{2 2}  68  87  68  87}
set config(5)   {{3 3}  73  128  73  128}
~~~

(each row defines a new config mode; numbers in nested braces are the speeds of the two fans; then two pair of numbers, one pair for plugged-in and one for battery; each pair of numbers is the temperature at which it should drop down into the next lower mode and the temperature at which it should jump up to the next mode)

Update: I had the settings like:

~~~no-highlight
set config(0)   {{0 0}  -1  62  -1  62}
set config(1)   {{1 0}  53  72  53  72}
set config(2)   {{1 1}  58  77  58  77}
set config(3)   {{2 1}  63  82  63  82}
set config(4)   {{2 2}  68  87  68  87}
set config(5)   {{3 3}  73  128  73  128}

# Speed values are set here to avoid i8kmon probe them at every time it starts.
set status(leftspeed)  "0 1000 1200 3000"
set status(rightspeed) "0 1000 1200 3000"
~~~

&hellip;and then I realised the fans were completely failing to respond to heavy compilation, so the compilation was slow, presumably due to throttling. When I changed it to:

~~~no-highlight
set config(0) {{1 0} -1 60 -1 65}
set config(1) {{1 1} 50 70 55 75}
set config(2) {{2 2} 60 80 65 85}
set config(3) {{3 3} 70 128 75 128}
~~~

&hellip;this situation was much improved.
