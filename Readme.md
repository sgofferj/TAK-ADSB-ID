# TAK ADSB ID collection
## Overview
This is a collection of specific ICAO hexids to make ATAK/WinTAK SA displays more meaningful. The idea is to use them in the middleware which feeds ADSB data as CoT objects into a TAK server.
I started out with Finland but pull requests are welcome.
## Civilian or military?
I use mostly the definitions of the country. In Finland, e.g. the Border Guard is considered not a military branch but a law enforcement agency under the Ministry of the Interior. Hence, at the moment, I classify FBG aircraft as "a-f-A-C-\*". Civilian aircraft, such as MediHelis, I generally classify as "a-n-A-C-\*". I might change this at a later point, though.
## Friendly, hostile, neutral?
I classify the aircraft from the point of view of somebody living in Finland. Finland is not at war with anybody at this point in time, so at the moment I do not classify any aircraft as hostile. If you feel, some aircraft should be classified as hostile, please download the files and use the search and replace function on your local copy.

**Update 2022-04-26:** Due to the Ukraine conflict and the changes in Finnish foreign policy, I reclassified all Russian planes as "hostile".
## Contributing
Please feel free to contribute to the list! Ideally, you would submit a pull request, but you can also open an issue. Please keep in mind what I wrote above under "Friendly, hostile, neutral?".
## Issues
I will try to handle issues fast but this is a hobby, I have a family and a busy work day, so please don't expect wonders!
## License
This repo is published under the Creative Commons Attribution-ShareAlike 4.0 International License.
