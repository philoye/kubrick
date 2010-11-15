# Kubrick

This is the **VERY EARLY** stages of the code required to support a Weather Balloon launch to "nearspace"(approximately 100,000 feet/30km.) The plan is to do real-time tracking and take HD video (and photos?) during the flight.

**Note:** We are a *very long* way from this stuff being ready.


## Why are you doing this? This has been done a million times right?

We are not certainly not the first to do this, but that doesn't make taking a picture of the curvature of earth and the blackness of space with your own camera any less cool.


## The pieces to the puzzle

The code is in several parts:

  1. **The flight computer**. An Arduino will talk to the onboard GPS, then write the output over serial to a wireless modem. Future plans to extend this to data from other sensors (barometric pressure, inside/outside temperature, etc.).

  2. **The Consumer**. This is a ruby program running locally on a laptop in the chase vehicle. The laptop is connected to the other end of the wireless serial modem. The consumer reads the GPS fixes from the serial port and then inserts them into a local Mongo database (and eventually a MongoDB instance in the cloud).

  3. **The Server**. A [Sinatra](http://www.sinatrarb.com/) webserver written that runs both locally in the chase vehicle and in the cloud for the world to see. It talks to the database and presents the Balloon path in a variety of (hopefully) interesting ways.
      * KML: An auto-updating KML feed that opens in Google Earth. This will be cool for real-time tracking on the ground and for those following along on the web. This can also be loaded into Google Maps, which we'll use on the site.
      * Web: A page that presents a mission control display. It will probably get its data via AJAX using...
      * JSON: A feed of the balloon progress.

  4. **The Queue** (not yet implemented): A message queue using RabbitMQ. Because the chase vehicle might not always have mobile coverage, we will add RabbitMQ to sit between the consumer and the two Mongo databases. That way, the server database can catch up and get all balloon fixes that is misses while we're offline.


There is also the minor matter of a balloon, helium, enclosure, communications, back up tracker, camera, parachutes, etc.
  

## Requirements

Do run everything, you'll need:

### Aruino

  * An Arduino and a GPS. For now, we're using an old [Duemilanove](http://www.sparkfun.com/commerce/product_info.php?products_id=666) and an [EM-406](http://www.sparkfun.com/commerce/product_info.php?products_id=465), but that is just for testing, we haven't yet decided on the real equipment. You can buy everything you need at [SparkFun](http://sparkfun.com) or [Little Bird Electronics](http://littlebirdelectronics.com).

  * You'll need the [Arduino SDK](http://arduino.cc) to run the above.

  * Set up a symlink between the Arduino synthetic usb serial port and the one that the "consumer" is looking for: `/dev/cuaa0`. Note, this symlink doesn't appear to persist after a restart. On my machine create it using:
  
        sudo ln -s /dev/tty.usbserial-A8008HDy /dev/cuaa0


### Mongo

You are using [homebrew](http://mxcl.github.com/homebrew/), right?

        brew install mongodb
        # and follow the instructions...
  
  
### Ruby

You'll need Ruby 1.9.2 (don't remember why), so install that (probably with [rvm](http://rvm.beginrescueend.com/)), then:

        # Assuming your Arduino/GPS are plugged in...
        # In one shell, fire up the consumer to start populating the db
        cd consumer
        bundle install
        bundle exec ruby balloon_consumber.rb

        # In another shell, fire up the server 
        cd ../server
        bundle install
        rake

        # visit http://0.0.0.0:3000 to view 'mission control'
        # visit http://0.0.0.0:3000/kubrick.kml to view progress in Google Earth, which should auto-update every 5 seconds.



## Want to learn more about this stuff?

Lots of people have done this before, a few links for inspiration:

  * Photos + Blog Post: [Adventures in High Altitude Ballooning](http://www.davidankers.com/?p=11), a launch out of Melbourne
  * Video: [Homemade Spacecraft](http://vimeo.com/15091562), by the Brooklyn Space Program
  * Video: [Near Space Balloon Flight, shot with HD HERO cameras from GoPro](http://vimeo.com/12488149?hd=1) by Kevin Macko
  * [SpaceBits](http://spacebits.eu/), very detailed writeup
  * [Balloon v1](http://vpizza.org/~jmeehan/balloon/), launch from way back in 2002.
  * [Apteryx, High Altitude Balloon](http://apteryx.hibal.org/)
  * [SPOC-1, Space Payload Onboard Camera](http://www.spaceduino.com/2009/12/spaceduino.html)
  * [BEAR: Balloon Experiments with Amateur Radio](http://bear.sbszoo.com/). Lots of info and photos here.
  * [HALO: High ALtitude Object](http://www.natrium42.com/halo/flight2/), videos, photos, and a blog post
  * [The Icarus Project](http://www.robertharrison.org/icarus/wordpress/about/), tons of resources here


## Who is involved?

So far it is [@philoye](http://twitter.com/philoye), [@benaskins](http://twitter.com/benaskins) and [@jonbartettuk](http://twitter.com/jonbartlettuk)

