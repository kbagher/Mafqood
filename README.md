Mafqood - مفقود
=======
Lost And Found App

AppStore Link: https://itunes.apple.com/us/app/mfqwd/id645701509?mt=8

![Mafqood App](http://a2.mzstatic.com/us/r30/Purple/v4/92/b0/7f/92b07f8c-2bd0-16d6-7f88-36a535ad0f66/screen568x568.jpeg)

## Backend
This app is using Parse.com as its backend, used classes are listed below:
- **User**: contains user information
    - **username (string)**: currently i use OpenUDID to provide the user id
    - **password (string)**: same as the username, using OpenUDID
    - **admin (boolean)**: is the user admin or not. check admin features section 
    - **blocked (boolean)**: is the user blocked or not
    - **country (string)**: using ISO country code to store user's country
- **Post**: contains the post information
    - **author (pointer)**: points to the user who added the post
    - **blocked (boolean)**: is this post blocked or not
    - **country (string)**: using ISO country code to store the post's country
    - **details (string)**: post details or description
    - **hasimage (boolean)**: does this post contain image or not
    - **image (file)**: contains the image file.
    - **location (string)**: where did the user lost his item
    - **reported (number)**: number of times this post got reported
    - **title (string)**: post title
    - **type (string)**: the post type, lost or found
- **PostContact**: the contact associated with this a specific post
	- **post (pointer)**: points to a post
    - **contactData (string)**: phone, email or anything else
    - **contactType (string)**: contact type; phone,kik,twitter or email
- **PostReport**: reporting log 
	- **post (pointer)**: points to the post that was reported
    - **user (pointer)**: points to the user who reported

## Admin Features
If the user field is set to be admin he will have several privileges such as:
- **Post Features**: when in the post details, shake the device and you will have the ability to do the following:
  1. Block the post
  2. Delete the post
  3. Block the user
- **General Features**: when in the settings view, shake the device and you will have the ability to do the following:
  1. Show posts from all countries. _Note: don't add any post while in this mode as the post won't have any location associated with it._


## Author
### Kassem M. Bagher
Email me if you have further questions: [kassem@bagher.me](mailto:kassem@bagher.me)

Follow me on twitter [@Kassem_Bagher](https://twitter.com/kassem_bagher)