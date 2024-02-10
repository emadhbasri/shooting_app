import 'package:flutter/material.dart';
import '../../classes/functions.dart';

class ChooseSharingWay extends StatelessWidget {
  const ChooseSharingWay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      child: Container(
        margin: EdgeInsets.all(doubleWidth(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Center(
              child: Text(AppLocalizations.of(context)!.select.toUpperCase(),style: Theme.of(context).textTheme.titleLarge ),
            ),
            SizedBox(height: doubleHeight(2)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  Go.pop(context,'stadia');
                },
                title: Text(AppLocalizations.of(context)!.sis),
                trailing: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/images/soccer(1).png')),
              ),
            ),SizedBox(height: doubleHeight(1)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  Go.pop(context,'shot');
                },
                title: Text(AppLocalizations.of(context)!.sof),
                trailing: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/images/soccer.png')),
              ),
            ),SizedBox(height: doubleHeight(1)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: ()async{
                  Go.pop(context,'chat');
                },
                title: Text(AppLocalizations.of(context)!.sog),
                trailing: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset('assets/images/chat.png')),
              ),
            ),

            SizedBox(height: doubleHeight(1)),
          ],
        ),
      ),
    );
  }
}
