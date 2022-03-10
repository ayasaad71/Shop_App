import 'package:flutter/material.dart';
import 'package:shop_app/modules/shop_login_screen/shop_login_screen.dart';
import 'package:shop_app/shared/Components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String title ;
  final String image ;
  final String body ;

  BoardingModel({
    required this.title,
    required this.image,
    required this.body,
});
}

bool isLast = false ;

class OnBoardingScreen extends StatefulWidget {

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  var boardController = PageController();

  List <BoardingModel> boarding = [
    BoardingModel(
      title: 'on boarding 1',
      image: 'assets/images/boarding_1.png',
      body: 'on boarder 1 body'
    ),
    BoardingModel(
        title: 'on boarding 2',
        image: 'assets/images/boarding_1.png',
        body: 'on boarder 2 body'
    ),
    BoardingModel(
        title: 'on boarding 3',
        image: 'assets/images/boarding_1.png',
        body: 'on boarder 3 body'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            onPressed: (){
              submit();
            },
            child: Text('Skip',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                itemBuilder: (context,index) => buildBoardItem(boarding[index]),
                itemCount: boarding.length,
                onPageChanged: (index){
                  if (index == boarding.length-1){
                    setState(() {
                      isLast = true ;
                    });
                  }else{
                    setState(() {
                      isLast = false ;
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 40,),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardController,
                    count: boarding.length,
                    effect: WormEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blue,
                      spacing: 10,
                      radius: 20
                    ),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: (){
                    if(isLast){
                      submit();
                    }else{
                      boardController.nextPage(
                        duration: Duration(
                          milliseconds: 750,
                        ),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon (Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void submit() {
    CacheHelper.saveData(key: 'OnBoarding', value: true).then((value) {
      if(value){
        navigateAndFinish(context, ShopLoginScreen());
      }
    });
}

  Widget buildBoardItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage('${model.image}'),
        ),
      ),
      SizedBox(height: 20,),
      Text('${model.title}',style: TextStyle(fontSize: 24),),
      SizedBox(height: 20,),
      Text('${model.body}',style: TextStyle(fontSize: 18)),
    ],
  );
}
