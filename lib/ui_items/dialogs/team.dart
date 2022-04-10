import 'package:flutter/material.dart';
import 'package:shooting_app/ui_items/shots/index.dart';
import '../../classes/functions.dart';
class TeamDialog extends StatefulWidget {
  @override
  State<TeamDialog> createState() => _TeamDialogState();
}

class _TeamDialogState extends State<TeamDialog> {

  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
          // color: Color(16777215),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: doubleWidth(2),vertical: doubleHeight(1)),
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Text('TERMS OF USE FOR FOOTBALL BUZZ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
              ),
              SizedBox(height: doubleHeight(2)),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                    children: [
                      TextSpan(text: '''Thank You for visiting [Football buzz].
Please read the following Terms and Conditions carefully before submitting your registration form to access Football Buzz’s Services.
\n'''),
                      TextSpan(text: 'AGREEMENT TO TERMS\n\n',style: bold),
                      TextSpan(text: '''These Terms and Conditions (this “Agreement”) constitute a legally binding agreement between You and GALLANT MEDIA LIMITED governing your use of the Football Buzz application and technology (collectively, the “Football Buzz Application).
If You are accessing our app on behalf of a company or organisation, You agree to the Agreement on behalf of that organisation and represent that You have authority to bind that company or organisation to the terms contained herein. If You do not have such authority, You must not accept this Agreement and must not use the Services accessible under it.

You agree that by accessing our Application, you have read, understood, and agree to be bound by all of these Terms and Conditions. If You do not agree with all the Terms and Conditions, then You are expressly prohibited from using our Application and You must discontinue use immediately.
The information provided on our Application is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject Us to any registration requirement within such jurisdiction or country. 
Accordingly, those persons who choose to access our Application from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable. 
\n'''),
                      TextSpan(text: 'Modification to the Agreement\n\n',style: bold),
                      TextSpan(text: '''We may change the terms and conditions of this Agreement from time to time. Such changes shall not be binding upon you unless we provide you with advance notice of such changes to this Agreement, in which case they will become effective on the date specified in the notice. To the extent permitted by law, continued use of our Application or Services after any such changes are in effect shall constitute your consent to such changes you agree that modification of this Agreement does not create a renewed opportunity to opt out of contractual obligations to Football Buzz. Football Buzz reserves the right to modify any information referenced in the hyperlinks from this Agreement from time to time, and such modifications shall become effective upon posting.\n'''),
                      TextSpan(text: '\nDEFINITIONS AND INTERPETATIONS\n\n',style: bold),
                      TextSpan(text: 'Services:\n\n',style: bold),
                      TextSpan(text: '''Football Buzz is an online social media platform for football fans. It provides micro blogging and messaging services to users.
You/Your: a User or any other individual or entity or end user accessing our Application, its contents, submitting the registration form, or participating in the Services offered through our Application, whether personally or on behalf of an entity.
We/Us/Our:  [Football buzz], [Football buzz] related parties and/or [Football buzz] partners.
Any use of the above or other words in the singular, plural, capitalisation and/or he/she or they, are taken as interchangeable and therefore as referring to same.
'''),
                      TextSpan(text: '''\nAGREED TERMS

WHAT IS IN THESE TERMS?  
\n''',style: bold),
                      TextSpan(text: 'These terms and Conditions inform you of the conditions under which you agree to use our Site.\n \n'),
                      TextSpan(text: 'ELIGIBILITY AND ACCESS TO OUR SERVICES\n\n',style: bold),
                      TextSpan(text: '''Our Application may only be used by individuals who can form legally binding contracts under applicable law. Our application is not available to children (persons under the age of majority in their jurisdiction or territory of residence)

Please note that when interact with our application, you are giving us (and our customers) ownership of the information you submit. You can’t usually erase those submissions later. You can, however, always erase your basic profile info, opt out of marketing, or close your account. We'll help you if you reach out to us.

You are a “User” if You have created or have been provided with a User identiﬁcation and password (“Account Information”) by a User (or by Us at a User’s request) or You have been granted access to Our Services User.

Users shall access Our Services via a device that meets the minimum technical requirements necessary to run the Services. Users must comply with the terms of this Agreement, and Users shall be responsible and liable for any User’s non-compliance with this Agreement.
\n\n'''),
                      TextSpan(text: 'THERE ARE OTHER TERMS THAT MAY APPLY TO YOU\n\n',style: bold),
                      TextSpan(text: '''This Agreement refer to the following additional term, which also apply to Your use of Our Services:
 
Our Privacy Policy [INSERT AS LINK TO FOOTBALL BUZZ APPLICATION’S PRIVACY POLICY]
\n'''),
                      TextSpan(text: 'WE MAY MAKE CHANGES TO OUR APPLICATION\n\n',style: bold),
                      TextSpan(text: 'We may update and change Our Application from time to time to reflect changes to Our Services, our Users’ needs and/or Our business priorities. We will try to give You reasonable notice of any major changes.\n'),
                      TextSpan(text: '\nYOU MUST KEEP YOUR ACCOUNT DETAILS SAFE',style: bold),
                      TextSpan(text: '''\n\nYou must keep Your Account Information safe, confidential and not disclose to a third party. We have the right to disable Your Account Information, if in Our reasonable opinion You have failed to comply with any of the provisions of this Agreement.
 
If You know or suspect that anyone other than You knows Your Account Information, and is likely to Use same against Your interest, You must promptly notify Us at [Support@footballbuzz.co].
\n'''),
                      TextSpan(text: 'FOOTBALL BUZZ APPLICATION CONTENT AND USER INFORMATION',style: bold),
                      TextSpan(text: '''\n\nAs a User, any data, information or materials You provide to our Application (“Our Application Content”) or otherwise provide to Us (“User Information”) must be accurate, correct, and up to date. Furthermore, You have a duty to maintain the accuracy of such information;
You shall not provide any User Data or Football Buzz Application Content that is infringing, fraudulent, illegal, libellous, defamatory, threatening obscene, abusive, deceptive, discriminatory, threatening, an invasion of privacy or violates the right of any third party.

As a User, You shall be solely responsible for, and assume the risk of, any problems resulting from User Information or Football Buzz Application Content submitted by any User under Your account. All User Information provided will be used only in accordance with the terms of Our Privacy Policy, as may be amended from time to time. 

By submitting/uploading Football Buzz Application Content and User Information to Our Application or to Us, You grant Us a non-exclusive, worldwide, perpetual, royalty-free, sub-licensable, transferable right and license to host, use, copy, transmit, access, read, store, publish, display, modify, distribute, and otherwise exploit it in any and all media.

We neither endorse nor assume any liability for the contents of any material uploaded or submitted by Users of our Application. We generally do not pre-screen, monitor, or edit the content posted by Users.
In uploading Football Buzz Application Content and/or providing User information, You shall not:
a)	Use content that is pornographic, defamatory, libellous, tortuous, vulgar, obscene, invasive of privacy, racially or ethnically objectionable, hateful, or promotes /provides instructional information about illegal activities, promotes any act of cruelty to animals, or is otherwise offensive;
b)	Use our Application and/or its Services to violate any federal, state, local or international laws;
c)	Spam Users or mass email Our Users in an automated fashion.
d)	Collect personal identifiable information about any User and sell or transfer that information;
e)	Harass, threaten, or intimidate a Useror others who use the Services;
f)	Use automation tools to create Profiles and/or content.
g)	Disclose a User’s confidential information; or
h)	Use content that is plagiarised, identical or substantially similar to any other copyright content, derived from a third party’s work and/or published elsewhere on the Web.
Your Application Content must be owned by You and You must not be infringing on any third party’s rights. Also, We reserve the right to terminate Your access to Our Services or remove any of Your Application Contents if You are found to be in breach of this Agreement and We shall have no obligation to provide a refund of any payment previously made to Us.
'''),
                      TextSpan(text: '\nYOUR WARRANTIES AS A USER OF OUR SERVICES',style: bold),
                      TextSpan(text: '''\n\nYou warrant that:
a)	You have full legal capacity to enter into legally binding relations under this Agreement;

b)	Your Use of this Application and participating in the Services under this Agreement does not and shall not conflict with the current legislation and/or any prescriptions, provisions, regulations, licenses, permits, and registrations applicable to You;

c)	When you use our Application, you agree to provide true, accurate and complete information, and to update this information to maintain its truthfulness, accuracy and completeness.

d)	Your Use of this Application and accessing its Services shall not cause any violation and/or non-fulfilment of any agreement or other instrument to which You are a party, or to the effect of which extends to You;

e)	You expressly consent to the public publication of certain data you may submit by our Customers. You consent to our Customers’ use of your information that is on our Application as described in the Privacy Policy. You agree you will not receive additional compensation for our Customers’ publication of that data.

f)	You shall not introduce viruses or any other computer code, files or programs designed to interrupt, destroy, or limit the functionality of the Services or our Application;

g)	You shall not modify, adapt or hack Our Application;

h)	You shall not upload, post, host, or transmit unsolicited email, SMSs, or "spam" messages;

i)	You shall not act in any manner that negatively affects the ability of others to use our Application;

j)	You shall not reproduce, duplicate, copy, sell, resell or exploit any portion of our Application, computer code that powers the Services, or access to the Services without Our express written permission;

k)	You shall not attempt to gain unauthorized access to the Services or their related systems or networks (including in a manner intended to circumvent a contractual Usage limit);

l)	You shall not access the Services in order to build a competitive product or service, or for purposes of monitoring its availability, performance or functionality, or for any other benchmarking or competitive purposes;

m)	You shall not reverse engineer, disassemble, decompile, decode or otherwise attempt to derive or gain access to the source code of the Services or any component thereof, except to the extent such restriction is permitted by applicable Law;

n)	You shall not attack Our Application via a denial-of-service attack or a distributed denial-of service attack;

o)	You shall not permit third parties to do any of the foregoing or to access or use the Services in a way that circumvents the provisions of this Agreement; and

p)	Where You have engaged a third party to obtain data and/or obtain Services from our Application on Your behalf, You understand that a breach of this Agreement by that third party shall be deemed to be a breach of the Agreement by You, and We shall have the right to take action against You on account of that breach (even if You had no knowledge of, and no involvement in, the said breach); and 

q)	You agree to indemnify and hold harmless anyone, including us and Users, who may be harmed in any way by the submittal of any untruthful, inaccurate or incomplete information. This indemnification includes the payment of any damages incurred, as well as any costs and attorney’s fees related to enforcing the indemnification and collecting any amounts due. We will collect, use and disclose your information as set forth in our Privacy Policy.
'''),
                      TextSpan(text: '\nDO NOT RELY ON INFORMATION ON THIS APPLICATION ',style: bold),
                      TextSpan(text: '\n\nAlthough We make reasonable efforts to update the information on Our Application, We make no representations, warranties or guarantees, whether express or implied, that the content on Our Application is accurate, complete or up to date.'),
                      TextSpan(text: '\n\nDISCLAIMER OF WARRANTIES',style: bold),
                      TextSpan(text: '''\n\nOur Application is provided “as is”. We hereby disclaim all warranties of any kind, express or implied, including and without limitation to the warranties of merchantability, fitness for a particular purpose and non-infringement. 

We make no warranty that our Application will be error-free or that access thereto will be continuous or uninterrupted. 

We do not guarantee the availability or uptime of our Application neither do We guarantee uninterrupted, accurate and faultless provision of the Services.

We do not guarantee that that the quality of any services, information, or other material obtained by You through the Services will meet Your expectations.

We do not guarantee that You will receive career opportunities, leads, or other opportunities that You desire on Our Application.

You expressly understand and agree that Your accessing Our Services is at Your sole risk as We do not guarantee that Our Application will be secure or free from bugs or viruses or other limitations. Any content downloaded or otherwise obtained through the use of this Football Buzz Application is downloaded at Your own risk and You shall be solely responsible for any damage to Your computer system or loss of data that results from such download or Your use of our Application.

You are responsible for configuring Your information technology, computer programmes and Application to access Our Application and You should use Your own virus protection software.
'''),
                      TextSpan(text: '\nEXCLUSION OF LIABILITY',style: bold),
                      TextSpan(text: '''\n\nWe do not exclude or limit in any way Our liability to You where it would be unlawful to do so. 
 
However, We shall not be liable to You for any loss or damage, whether in contract, tort (including negligence), breach of statutory duty, or otherwise, even if foreseeable, arising under or in connection with:

•	use of, or inability to use, Our Application; or
•	use of or reliance on any content displayed on Our Application.

In particular, We shall not be liable for:

•	loss of profits, sales, business, or revenue;
•	business interruption;
•	loss of anticipated savings;
•	loss of business opportunity, goodwill or reputation; or
•	any indirect or consequential loss or damage.

We shall not be liable for any and all losses for infringement of patents, copyrights, trademarks or any other intellectual property right or trade secrets misappropriation arising out of Our Application Contents that You access, submit, upload or transmit through Your use of or connection to our Application.
'''),
                      TextSpan(text: '\nBACKING UP AND SECURING USER INFORMATION',style: bold),
                      TextSpan(text: '\n\nYou are solely responsible for securing and backing up Your User Information used on our Application as We shall not be responsible for any loss of data or information.'),
                      TextSpan(text: '\n\nINTELLECTUAL PROPERTY IN OUR APPLICATION ',style: bold),
                      TextSpan(text: '''\n\nThe Agreement does not transfer the intellectual property rights in our S
Application to You or any third party. All rights, titles, and interests in and to all such property remains solely with Us. All trademarks, service marks, graphics and logos used in connection with our Application are trademarks of Football Buzz.

Except as expressly provided in this Agreement, no part of our Application and no Content or Marks shall be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, modified, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without Our express prior written permission.
Provided that You are eligible to use our Application, You are granted a limited license to access and use our Application and to download or print a copy of any portion of our Application Content to which You have properly gained access solely for Your personal, non-commercial use. 
We reserve all rights not expressly granted to You in and to our Application, the Content and the Marks.
'''),
                      TextSpan(text: '\nRULES ABOUT LINKING TO OUR APPLICATION ',style: bold),
                      TextSpan(text: '''\n\nYou may link to Our home page, provided You do so in a way that is fair and legal and does not damage Our reputation or take advantage of it.
 
You must neither establish a link to Our Application in any Football Buzz Application that is not owned by You nor establish a link in such a way as to suggest any form of association, approval or endorsement on Our part where none exists.
 
The Application which You are linking must comply in all respects with the content standards set out in Our Your Warranties as a User of Our Services Clause [INSERT AS LINK] and We reserve the right to withdraw linking permission without notice.

'''),
                      TextSpan(text: 'LINKS TO OTHER WEBSITES ',style: bold),
                      TextSpan(text: '\n\nOur Application may contain links to other Websites of interest. However, once You have clicked on any of the links to leave Our Application, You should note that We do not have any control over other Websites. Therefore, We cannot be responsible for the protection and privacy of any information which You provide whilst visiting such Websites as such Websites are not governed by Our Privacy Policy. You should exercise caution and take a look at the privacy Policy applicable to the Website in question. '),
                      TextSpan(text: '\n\nTERMINATION',style: bold),
                      TextSpan(text: '''\n\nThis Agreement is effective upon your creation of a User account. This Agreement may be terminated: a) by User, without cause, upon seven (7) days’ prior written notice to Football Buzz; or b) by either Party immediately, without notice, upon the other Party’s material breach of this Agreement. In addition, Football Buzz may terminate this Agreement or deactivate your User account immediately in the event: (1) you no longer qualify to provide Services under applicable law, rule, permit, ordinance or regulation; (2) Football Buzz has the good faith belief that such action is necessary to protect the safety of the Football Buzz community or third parties, provided that in the event of a deactivation pursuant to (1)-(2) above, you will be given notice of the potential or actual deactivation and an opportunity to attempt to cure the issue to Football Buzz’s reasonable satisfaction prior to Football Buzz permanently terminating the Agreement. For all other breaches of this Agreement, you will be provided notice and an opportunity to cure the breach. If the breach is cured in a timely manner and to Football Buzz’s satisfaction, this Agreement will not be permanently terminated.

Upon termination or expiration of this Agreement: (a) all outstanding fees (if any) shall be immediately due and payable; (b) The User shall cease and shall cause all Users to cease accessing or using our Application in any form or manner; and (c) Users’ access to our Application will be automatically terminated, all Account Information shall be deleted and all User Information may be destroyed.

On no account shall the termination of this Agreement relieve a User of the obligation to pay any fees payable to Us for the period prior to the effective date of termination.

All provisions of the Agreement which by their nature should survive its termination shall survive termination, including, without limitation, intellectual property, confidentiality, disclaimer of warranties and limitations of liability.
'''),
                      TextSpan(text: '\nINDEMNIFICATION',style: bold),
                      TextSpan(text: '''\n\nYou agree to indemnify, defend and hold harmless Football Buzz, its directors, officers, employees, consultants, agents, and affiliates, from any and all third party claims, liability, damages and/or costs (including, but not limited to, legal fees) arising from Your use of Our Application or Your breach of this Agreement.
You shall defend, indemnify and hold harmless Football Buzz from any and all losses arising from falsification of data or forgery of documents by a User and for infringement of patents, copyrights, trademarks or any other intellectual property right or trade secrets misappropriation arising out of Football Buzz Application Contents that You submit, upload or transmit through Your use of or connection to our Application.
'''),
                      TextSpan(text: '\nRELEASE',style: bold),
                      TextSpan(text: '''\n\nYou agree that We shall be responsible for determining, in Our absolute discretion, our Application Contents to be selected and considered by Us for grants and/or aids, with respect to Our Services. Where a dispute arises between You and one or more Users, or on the transparency of Our selection or consideration process in relation to accessing Our Services, You shall release Football Buzz from all claims, demands, liabilities, costs or expenses and damages actual and consequential of every kind and nature, known and unknown, arising out of or in any way connected with such disputes.
In entering into this Agreement, You expressly waive any protections (whether statutory or otherwise) to the extent permitted by applicable law, that would otherwise limit the coverage of this release to include only those claims which You may know or suspect to exist in Your favour at the time of this Agreement.
'''),
                      TextSpan(text: '\nINVESTIGATIONS',style: bold),
                      TextSpan(text: '''\n\nWe reserve the right to investigate suspected violations of this Agreement, including and without limitation to any violation arising from any submission or upload of Football Buzz Application Content to Our Application. We may seek to gather information from the User who is suspected of violating this Agreement, and from any other User.
We may suspend any User whose conduct or uploads are under investigation and may remove such Application Content from Our servers as it deems appropriate and without notice.
Where We believe, in Our sole discretion, that a violation of this Agreement has occurred, We may edit or modify, and remove the relevant Application Content permanently, warn and suspend Users, terminate accounts or take other corrective actions if deemed appropriate.
We shall fully cooperate with any law enforcement authorities or court order requesting or directing Us to disclose the identity of anyone who has uploaded Football Buzz Application Contents that are believed to have violated this Agreement.
'''),
                      TextSpan(text: '\nDEALINGS WITH THIRD PARTIES',style: bold),
                      TextSpan(text: '\n\nYour correspondence or business dealings with third parties accessed through any of Our Services are solely between You and such parties. You agree that We shall not be responsible or liable for any loss or damage of any sort incurred as the result of any such dealings.'),
                      TextSpan(text: '\n\nFORCE MAJEURE',style: bold),
                      TextSpan(text: '\n\nNeither shall We or You be liable for any failure or delay in performance hereunder due to any cause beyond its reasonable control including, but not limited to, acts of God or public enemy, fire explosions,  epidemics, pandemics, accidents, strikes, governmental actions, delay or failure of Our systems or carriers or other difficulties with telecommunications networks provided that the party so effected notifies the other promptly of the commencement, nature and estimated duration of the cause.'),
                      TextSpan(text: '\n\nWAIVER AND SEVERABILITY',style: bold),
                      TextSpan(text: '''\n\nAny remedy set forth in this Agreement is in addition to any other remedy afforded to us under applicable Law or otherwise. Our failure to exercise or enforce any right or provision of this Agreement shall not constitute a waiver of such right or provision.
If any provision of this Agreement is found by a court to be void, invalid or unenforceable, same shall be reformed to comply with applicable law or struck out if not so conformable, so as not to affect the validity or enforceability of this Agreement.
If any provision of this Agreement is held by a court of competent jurisdiction to be contrary to law, the remaining provisions of this Agreement shall remain in full force and effect.
'''),
                      TextSpan(text: '\nENTIRE AGREEMENT',style: bold),
                      TextSpan(text: '\n\nThis Agreement, including links to other terms referred to in it, constitutes Our entire terms and understanding with respect to its subject matter and replaces and supersedes all prior or contemporaneous agreements or undertakings regarding such subject matter.'),
                      TextSpan(text: '\n\nWHICH COUNTRY’S LAWS APPLY TO ANY DISPUTES?',style: bold),
                      TextSpan(text: '''\n\nThis Agreement shall be governed by and construed in accordance with the laws of The United Kingdom and Wales.
The parties irrevocably agree that the courts of the United Kingdom and Wales shall have exclusive jurisdiction to settle any dispute or claim (including non-contractual disputes or claims) arising out of or in connection with this document or its subject matter or formation.
'''),
                      TextSpan(text: '\nCHANGES',style: bold),
                      TextSpan(text: '''\n\nWe reserve the right, at Our sole discretion, to modify or replace any part of this Agreement (including Our Privacy Policy). Where same is modified, We will post a notice that will be conspicuously visible on Our Application.
Every time You wish to Use Our Services, please check this Agreement to ensure You understand the terms that apply at that time. If You disagree with or do not accept any such changes, Your sole option is to terminate Your use of our Application. If You do so, We shall cancel Your Account.
Your continued Use of or access to Our Application following such notice or such a posting of a notice constitutes acceptance of those changes.
'''),
                    ],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: doubleWidth(3.5),
                    )),
              ),
            ],
          )
      ),
    );
  }
  bool loading=true;
}

const bold = TextStyle(fontWeight: FontWeight.bold);


