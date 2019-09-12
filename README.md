# Flash-Speedtest.net-by-Ookla
This is Ooklas old Flash based Speedtest the best speedtest that ever existed

### You can still use it today
if you want to ever use Flash speedtest again you can still do it because server deamons are compatible so new speedtest still works with them which means you only need to host the player up and it can be still used to test your internet connection :smile:

### How it all happened

It was 2016
For awhile I wanted to test my local LAN speed, I know I have gigabit but how much realy can I upload to my server??

I knew that speedtest.net was the best speedtest for me and I wanted to have it, I never got around to seting it up until one day in 2017 they decided to force a new crappy HTML5 speedtest for everyone, that was it; I knew I will have to act fast, I wanted to still use it

I then discovered that it was still uvailable on http://legacy.speedtest.net, and the documentation was still up

The product Ookla was seling was called Netgauge, so i said OK lets set it up

I read documentation which is gone from the web by now but still here in this repo, and I started to crack Okklas Speedtest
after decompiling their flash source there was a problem the source used [SecureSWF]: http://www.kindi.com/actionscript-obfuscator.php
after working through the code and figuring out the date part of the license I gave up and started to try it a diferent way

then a year went by and it was already 2016 after talking a break another year went by and it was March in 2017

I tried again and found their old Latency Test used a diferent obfuscacator [Amayeta SWF Decrypt]: http://www.amayeta.com/software/swfencrypt/ it was crappy so I deobfuscacated by hand it required a day of copy/pasting and code rewriting but I had the algorithm

and the thing worked but only in Latency Test, license didn't work on any recent speedtest or Netgauge versions, damm, what did I do wrong?, well it turnes out that oOkla used a diferent secrets, after finding the secrets they used I was up and running

I wrote a niece javascript function to generate myself a license, it also works with Netgauge and Latency Test

but I wanted more, I wanted easy to read source code, then I find it, Netgauge was hiding it all along

SecureSWF has an option to use their loader to further hide the source, the loader is obfuscacated but wait.....
only the loader is obfuscated, once the bytes are decrypted its all there, all the source in almost compile state, easy to read and enjoy looking at, and best of all all Netgauges have it, you only have to extraxt the swf from RAM

in September 2017 I rewrote the keygen in C#

in January 2017
after having the sources, the keygen in 2 languages it still wasn't enough, I wanted some custumized versions of Netgauge consumers(telcos) had on their websites to test internet speed, so I download them, organized them and wrote where I got them from, unfortionaly most of them are gone from the internet but they are still here on this repo for people to remember them, even if they were stil up their licenses slowly expired and the last one did in 01.01.2019, but you can generate new licenses as you have the keygen

but I wanted the API Ookla uses to show the results, I saved the pictures and decided to rewrite it but....
in February 2017 (02.02.2017) to be precise everything changed my happines was better than ever and I completely forgot who I am, for once I didn't need a computer or a radio to be happy, I just was every day and every night, being awake was better then being asleep :smile::smile::smile::smile::smile::smile::smile::smile::smile::smile::smile::smile::smile::smile::smile::smile::smile::smile::smile:

but I knew :sad:, I kne... my happiness will end as I had to go, and in 11.07.2018 as we knew the results for national Matura it was the last day, after that I slowly walked out of high-school :sad:, and my happiness ended :sad: and it still hasn't returned 

I did all this in the time I was still happy, I got an F occasionaly but....life was so so sweat :smile:, this is the song that makes me normal now and describes that times for a bit: [Ana Bekuta - Ljubav bez adrese]: https://www.youtube.com/watch?v=bZoxRLwfBX0
and this one: [Ana Bekuta - Voli me voli]: https://www.youtube.com/watch?v=NrChc23jn50

the songs are in Serbian and if their names would be translated into English the first would be ``` Ljubav bez adrese => Love without adress ``` and ```Voli me voli => love me love me????(hmm as Croatian is not my native language I cannot realy properly translate it :( ```

after the last day I couldn't stare at all this and almost deleted it and now I feel a bit better when looking at it as I wrote my heart out in a README nobody would ever read

REMEMBER IF YOU EVER fall for someone you should do what is best for her not for yourself, because only then you can be sure you are doing nothing wrong
