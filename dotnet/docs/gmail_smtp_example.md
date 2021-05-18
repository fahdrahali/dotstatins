
# How to setup SMTP service using the docker-compose examples?
By default, the docker compose examples are not configured to send emails to the users during data imports and transactions.

>  **This feature is optional for development, testing or demoing purposes.** If it is not enabled, the developer or system administrator can review the user's activity in the Transfer service's log files. By default they are located in the file /logs/user-activity.log inside the transfer-service container, with the log LEVEL **NOTICE**

**To enable this feature, a SMTP service is required.**

>  `For production deployments we recommend using a email delivery service`; Your hosting provider or your organization might be able to provide it. Another option is to pay for a third party email provider.


## Example on how to set up Gmail SMTP service
This is a good free alternative for this test. This service comes with a limit of the amount of emails that can be send per day ([See more](https://support.google.com/a/answer/2956491?hl=en-419)). 
For this setup, we will use the **app-password** mode, which will allow not to use the personal gmail password, but rather one dedicated for our application.

### Step 1: [Enable 2-step verification](https://www.google.com/landing/2step/)

The very first thing you will need to do is ensure that you have 2-step verification enabled on your primary Gmail account. 

**`Important:`** If you don’t do this you will get an invalid password error further below when trying to authenticate your email address.

### Step 2: [Generate App Password ](https://security.google.com/settings/security/apppasswords)

Next, you will need to generate an App password. You then use the app password in place of your personal Gmail password in the next step. 

**`If you haven’t enabled 2-step verification you will get an error saying`** “The setting you are looking for is not available for your account.”

Select Other/Custom name from Select App, give it a name such as “dotStatSuite - Demo Server” and then click Generate.

**This will generate a password you will need to save for later.**

### Step 3: Configure Gmail SMTP 

In the file **".env"**, modify the following variables:
* SMTP_HOST=smtp.gmail.com
* SMTP_PORT=587
* SMTP_SSL=true
* SMTP_USER=yourgmail@gmail.com 
* SMTP_PASSWORD=App password (The password created in step 2).
 
Save the changes  

