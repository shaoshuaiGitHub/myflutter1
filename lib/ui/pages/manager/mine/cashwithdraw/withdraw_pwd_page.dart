import 'package:flutter/material.dart';
import 'package:youxinbao/common/component_index.dart';
import 'package:youxinbao/res/res_index.dart';
import '../../../../widgets/keyboard.dart';
import '../../../../widgets/password_field.dart';
import 'withdraw_confirm_page.dart';
import 'withdraw_money_page.dart';

class MyWithdrawPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyWithdrawPage();
}

class _MyWithdrawPage extends State<MyWithdrawPage> {
  /// 用户输入的密码
  String pwdData = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // VoidCallback：没有参数并且不返回数据的回调
  VoidCallback _showBottomSheetCallback;
  bool isOpen = false;

  @override

  /// 密码键盘的整体回调，根据不同的按钮事件来进行相应的逻辑实现
  void _onKeyDown(data) {
    ///如果点击了删除按钮，则将密码进行修改
    if (data.isDelete()) {
      if (pwdData.length > 0) {
        pwdData = pwdData.substring(0, pwdData.length - 1);
        setState(() {
          pwdData = pwdData;
        });
      }
      print(pwdData);
    }
// 点击了确定按钮时
    else if (data.isCommit()) {
      if (pwdData.length != 6) {
        showToast("密码不足6位，请重试");
        return;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => WithdrawConfirmPage(
                  pwd: pwdData,
                ),
          ),
        );
      }
    }
//点击了数字按钮时  将密码进行完整的拼接
    else {
      if (pwdData.length < 6) {
        pwdData += data.key;
      }
      setState(() {
        pwdData = pwdData;
      });
      print(pwdData);
    }
  }

  @override
  void showToast(String msg, {int duration, int gravity: 0}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showBottomSheet;
  }

  void _showBottomSheet() {
    if (isOpen) {
      return null;
    } else {
      isOpen = true;
      _scaffoldKey.currentState
          .showBottomSheet<void>((BuildContext context) {
            return Container(
              height: 230,
              child: MyKeyboard(callback: (val) => _onKeyDown(val)),
            );
          })
          .closed
          .whenComplete(() {
            if (mounted) {
              setState(() {
                // re-enable the button  // 重新启用按钮
                isOpen = false;
                _showBottomSheetCallback = _showBottomSheet;
              });
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colours.orange_72,
        centerTitle: true,
        elevation: 0,
        title: Text(
          '提现',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeights.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 40,
            margin: const EdgeInsets.only(
              top: 50,
            ),
            child: Center(
              child: Text(
                '请设置提现密码',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeights.medium,
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ),
          Container(
            width: 272,
            height: 46,
            margin: const EdgeInsets.only(
              top: 45,
            ),
            child: GestureDetector(
              child: Container(
                width: 250.0,
                height: 40.0,
                child: CustomJPasswordField(
                  data: '$pwdData',
                ),
              ), // 用户点击输入框的时候，弹出自定义的键盘
              onTap: () {
                _showBottomSheetCallback();
              },
            ),
          ),
          Container(
            width: 270,
            margin: const EdgeInsets.only(
              top: 31,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MaterialButton(
                  minWidth: 0,
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    _onKeyDown(KeyEvent("commit"));
                  },
                  child: Container(
                    width: 78,
                    height: 28,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colours.orange_72,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        '下一步',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colours.orange_72,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 46,
            margin: const EdgeInsets.only(
              top: 50,
            ),
            child: Center(
              child: MaterialButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          WithdrawMoneyManagerPage(type: 1),
                    ),
                  );
                },
                child: Text(
                  '跳过',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}