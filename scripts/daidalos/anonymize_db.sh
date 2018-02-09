#!/bin/bash

login="psql ef24 -tAc "
directory="$HOME/Downloads/daidalos-tmp"

# anonymize Users
${login} "update dbo.account set accountname='Taylor Swift'"
${login} "update dbo.account set accountname='Chuck Norris' where id > 10000 AND id < 130000"
${login} "update dbo.account set accountname='Vasily Zaytsev' where id > 130000 AND id < 160000"
${login} "update dbo.account set accountname='Fiete Arp' where id > 160000 AND id < 220000"
${login} "update dbo.account set accountname='Kylo Ren' where id > 220000 AND id < 250000"

# anonymize Streets
${login} "update dbo.address set street='Diagon Alley'"
${login} "update dbo.address set street='Sesame Street' where id > 5000 and id < 45000"
${login} "update dbo.address set street='Kingsroad' where id > 45000 and id < 100000"
${login} "update dbo.address set street='Baker Street' where id > 100000 and id < 150000"
${login} "update dbo.address set street='Abbey Road' where id > 150000 and id < 200000"

# anonymize Bank accounts
${login} "update dbo.bankaccount set iban='AT611904300234573202' where iban ILIKE 'AT%'"
${login} "update dbo.bankaccount set iban='DE89370400030532013421' where iban not ILIKE 'AT%'"
${login} "update dbo.bankaccount set iban='DE89370400440532013000' where id > 0 and id < 200000 and iban not ILIKE 'AT%'"
${login} "update dbo.bankaccount set iban='DE26500105175288388414' where id > 250000 and id < 300000 and iban not ILIKE 'AT%'"
${login} "update dbo.bankaccount set iban='DE12500105170648489890' where id > 300000 and id < 350000 and iban not ILIKE 'AT%'"
${login} "update dbo.bankaccount set iban='DE12500105100628449820' where id > 350000 and id < 500000 and iban not ILIKE 'AT%'"
${login} "update dbo.bankaccount set iban='DE12500515200328449821' where id > 500000 and id < 700000 and iban not ILIKE 'AT%'"

# anonymize Owner Name
${login} "update dbo.bankaccount set ownername='Taylor Swift'"
${login} "update dbo.bankaccount set ownername='Chuck Norris' where id > 0 and id < 200000"
${login} "update dbo.bankaccount set ownername='Vasily Zaytsev' where id > 200000 and id < 300000"
${login} "update dbo.bankaccount set ownername='Fiete Arp' where id > 300000 and id < 400000"
${login} "update dbo.bankaccount set ownername='Kylo Ren' where id > 400000 and id < 600000"
${login} "update dbo.bankaccount set ownername='' where id > 600000 and id < 800000"

# anonymize Party Name
# Some partys dont have a name so Value is 0
${login} "update dbo.bankaccountbooking set partyname='Taylor Swift'"
${login} "update dbo.bankaccountbooking set partyname='Chuck Norris' where id > 0 and id < 200"
${login} "update dbo.bankaccountbooking set partyname='Vasily Zaytsev' where id > 200 and id < 300"
${login} "update dbo.bankaccountbooking set partyname='Fiete Arp' where id > 300 and id < 400"
${login} "update dbo.bankaccountbooking set partyname='Kylo Ren' where id > 400 and id < 600"
${login} "update dbo.bankaccountbooking set partyname='' where id > 600 and id < 800"

# anonymize company name 
${login} "update dbo.client set companyname1='Muckibude'"
${login} "update dbo.client set companyname1='Bizeps statt salat' where customerid > 5000 and customerid < 8000"
${login} "update dbo.client set companyname1='Gymlab' where customerid > 2000 and customerid < 4000"
# anonymize company name 2
${login} "update dbo.client set companyname2='Taylor Swift'"
${login} "update dbo.client set companyname2='Kylo Ren' where customerid > 5000 and customerid < 8000"
${login} "update dbo.client set companyname2='Fiete Arp' where customerid > 2000 and customerid < 4000"

# anonymize Street
${login} "update dbo.client set street='Diagon Alley'"
${login} "update dbo.client set street='Sesame Street' where customerid > 5000 and customerid < 8000"
${login} "update dbo.client set street='Kingsroad' where customerid > 2000 and customerid < 4000"

# anonymize Random numbers in bankaccount field
${login} "update dbo.client set bankaccount='DE89370400030532013421'"

# anonymize Mails/Phone Numbers in Communicationchannel
${login} "update dbo.communicationchannel set value='Taylor@swift.de'"
${login} "update dbo.communicationchannel set value='0170123456789' where channeltype = 4"

# anonymize Deltavistareply
${login} "update dbo.deltavistareply set foundname='Swift'"
${login} "update dbo.deltavistareply set foundfirstname='Taylor'"
${login} "update dbo.deltavistareply set foundstreet='Diagon Alley'"
${login} "update dbo.deltavistareply set foundname='Norris' where id > 40 and id < 70"
${login} "update dbo.deltavistareply set foundfirstname='Chuck' where id > 70 and id < 120"
${login} "update dbo.deltavistareply set foundstreet='Kingsroad' where id > 40 and id < 120"

# anonymize deltavistarequest
${login} "update dbo.deltavistarequest set searchedname='Swift'"
${login} "update dbo.deltavistarequest set searchedfirstname='Taylor'"
${login} "update dbo.deltavistarequest set searchedstreet='Diagon Alley'"
${login} "update dbo.deltavistarequest set searchedname='Norris' where id > 100 and id < 400"
${login} "update dbo.deltavistarequest set searchedfirstname='Chuck' where id > 100 and id < 400"
${login} "update dbo.deltavistarequest set searchedstreet='Kingsroad' where id > 100 and id < 400"

# anonymize directdevitmandate
${login} "update dbo.directdebitmandate set debitoriban='AT611904300234573202' where debitoriban ILIKE 'AT%'"
${login} "update dbo.directdebitmandate set debitoriban='DE89370400440532013000' where debitoriban not ILIKE 'AT%'"
${login} "update dbo.directdebitmandate set debitoriban='DE89370400445542932001' where debitoriban not ILIKE 'AT%' and id > 35000 and id < 45000"

# anonymize more bank accounts
${login} "update dbo.directdebitpaymentinstruction set creditoraccountiban='AT611904300234573202' where creditoraccountiban ILIKE 'AT%'"
${login} "update dbo.directdebitpaymentinstruction set creditoraccountiban='DE89370400440532013000' where creditoraccountiban not ILIKE 'AT%'"
${login} "update dbo.directdebitpaymentinstruction set creditoraccountiban='DE12500105100628449820' where creditoraccountiban not ILIKE 'AT%' and id > 700 and id < 1000"
${login} "update dbo.directdebitpaymentinstruction set cdtrschmeid='AT611904300234573202' where cdtrschmeid ILIKE 'AT%'"
${login} "update dbo.directdebitpaymentinstruction set cdtrschmeid='DE89370400440532013000' where cdtrschmeid not ILIKE 'AT%'"
${login} "update dbo.directdebitpaymentinstruction set cdtrschmeid='DE12500105100628449820' where cdtrschmeid not ILIKE 'AT%' and id > 700 and id < 1000"

# anonymizing Ef24 user
${login} "update dbo.ef24_user set firstname='Taylor'"
${login} "update dbo.ef24_user set lastname='Swift'" 
${login} "update dbo.ef24_user set email='Taylor@swift.de'"
${login} "update dbo.ef24_user set firstname='Chuck' where id > 20 and id < 60"
${login} "update dbo.ef24_user set lastname='Norris' where id > 20 and id < 60"
${login} "update dbo.ef24_user set email='chuck@norris.de' where id > 20 and id < 60"
${login} "update dbo.ef24_user set firstname='Fiete' where id > 60 and id < 120"
${login} "update dbo.ef24_user set lastname='Arp' where id > 60 and id < 120"
${login} "update dbo.ef24_user set email='fiete.arp@hsv.de' where id > 60 and id < 120"

# anonymizing more Emails
${login} "update dbo.email set toemail='taylor@swift.de'"
${login} "update dbo.email set toemail='chuck@norris.de' where id > 20 and id < 140"
${login} "update dbo.email set toemail='fiete.arp@hsv.de' where id > 150 and id < 400"

# anonymizing Notidentifiedcreditreturn
${login} "update dbo.notidentifiedcreditreturn set partyname='Taylor Swift'"
${login} "update dbo.notidentifiedcreditreturn set partyname='Chuck Norris' where id > 40 and id < 100"
${login} "update dbo.notidentifiedcreditreturn set partyname='Fiete Arp' where id > 110 and id < 240"
${login} "update dbo.notidentifiedcreditreturn set partyname='Harry Potter' where id > 250 and id < 400"
${login} "update dbo.notidentifiedcreditreturn set iban='AT611904300234573202' where iban ILIKE 'AT%'"
${login} "update dbo.notidentifiedcreditreturn set iban='DE89370400440532013000' where iban not ILIKE 'AT%'"
${login} "update dbo.notidentifiedcreditreturn set iban='DE89370400440511525570' where iban not ILIKE 'AT%' and id > 80 and id < 150"

# anonymizing Party
${login} "update dbo.party set firstname='Taylor'"
${login} "update dbo.party set name='Swift'"
${login} "update dbo.party set firstname='Chuck' where id > 100000 and id < 200000"
${login} "update dbo.party set name='Norris' where id > 100000 and id < 200000"
${login} "update dbo.party set firstname='Harry' where id > 200000 and id < 300000"
${login} "update dbo.party set name='Potter' where id > 200000 and id < 300000" 

# anonymizing partyhistory
${login} "update dbo.partyhistory set firstname='Taylor'"
${login} "update dbo.partyhistory set name='Swift'"
${login} "update dbo.partyhistory set firstname='Chuck' where id > 100000 and id < 200000"
${login} "update dbo.partyhistory set name='Norris' where id > 100000 and id < 200000"
${login} "update dbo.partyhistory set firstname='Harry' where id > 200000 and id < 300000"
${login} "update dbo.partyhistory set name='Potter' where id > 200000 and id < 300000"

# anonymizing Studiocontract
${login} "update dbo.studiocontract set iban='AT611904300234573202' where iban ILIKE 'AT%'"
${login} "update dbo.studiocontract set iban='DE89370400440532013000' where iban not ILIKE 'AT%'"
${login} "update dbo.studiocontract set iban='DE89370400440511525570' where iban not ILIKE 'AT%' and id > 500 and id < 700"
${login} "update dbo.studiocontract set iban='DE12500105100628449820' where iban not ILIKE 'AT%' and id > 700 and id < 900"
${login} "update dbo.studiocontract set studioname='Muckibude'"
${login} "update dbo.studiocontract set studioname='Bizeps statt salat' where id > 500 and id < 700"
${login} "update dbo.studiocontract set studioname='Gymlab' where id > 700 and id < 900"

# anonymizing Studiomembercredit
${login} "update dbo.studiomembercredit set iban='AT611904300234573202' where iban ILIKE 'AT%'"
${login} "update dbo.studiomembercredit set iban='DE89370400440511525570' where iban not ILIKE 'AT%'"
${login} "update dbo.studiomembercredit set iban='DE12500105100628449820' where iban not ILIKE 'AT%' and id > 200 and id < 500"
${login} "update dbo.studiomembercredit set iban='DE89370400428511945170' where iban not ILIKE 'AT%' and id > 500 and id < 900"
${login} "update dbo.studiomembercredit set partyname='Taylor Swift'"
${login} "update dbo.studiomembercredit set partyname='Chuck Norris' where id > 200 and id < 500"
${login} "update dbo.studiomembercredit set partyname='Harry Potter' where id > 700 and id < 900"

# anonymizing Studiosite
${login} "update dbo.studiosite set name='Muckibude'"
${login} "update dbo.studiosite set name='Bizeps statt Salat' where id > 50 and id < 100"
${login} "update dbo.studiosite set name='Gymlab' where id > 100 and id < 140"

