import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import 'calculator_button.dart';
class BasicKeypad extends StatelessWidget
{
  const BasicKeypad({super.key});
  @override
  Widget build(BuildContext context)
  {
    final isDark=Theme.of(context).brightness==Brightness.dark;
    final num=isDark?AppColors.btnNumberDark:AppColors.btnNumberLight;
    final fn=isDark?AppColors.btnFunctionDark:AppColors.btnFunctionLight;
    final op=AppColors.btnOperatorDark;
    final eq=AppColors.lightAccent;
    final numTxt=isDark?Colors.white:AppColors.textDark;
    final fnTxt=isDark?Colors.white:AppColors.textDark;
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal:12),
      child:Column(
        children:
        [
          _buildRow(context,
              labels:['C','CE','%','÷'],
              colors:[fn,fn,fn,op],
              txtColors:[fnTxt,fnTxt,fnTxt,Colors.white]),
          _buildRow(context,
              labels:['7','8','9','×'],
              colors:[num,num,num,op],
              txtColors:[numTxt,numTxt,numTxt,Colors.white]),
          _buildRow(context,
              labels:['4','5','6','-'],
              colors:[num,num,num,op],
              txtColors:[numTxt,numTxt,numTxt,Colors.white]),
          _buildRow(context,
              labels:['1','2','3','+'],
              colors:[num,num,num,op],
              txtColors:[numTxt,numTxt,numTxt,Colors.white]),
          _buildRow(context,
              labels:['±','0','.','='],
              colors:[num,num,num,eq],
              txtColors:[numTxt,numTxt,numTxt,Colors.white]),
        ],
      ),
    );
  }
  Widget _buildRow(BuildContext context,
   {
    required List<String> labels,
    required List<Color> colors,
    required List<Color> txtColors,
  }) {
    return Expanded(
      child:Row(
        children:List.generate(labels.length,(i)
        {
          if(labels[i]=='C')
          {
            return CalculatorButton(
              text:'C',
              bgColor:colors[i],
              textColor:txtColors[i],
              onTap:()=>_handle(context,'C'),
              onLongPress:()=>_clearHistory(context),
            );
          }
          return CalculatorButton(
            text:labels[i],
            bgColor:colors[i],
            textColor:txtColors[i],
            onTap:()=>_handle(context,labels[i]),
          );
        }),
      ),
    );
  }

  void _clearHistory(BuildContext context)
  {
    context.read<HistoryProvider>().clearHistory();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content:Text('History cleared'),
      duration:Duration(seconds:1),
      backgroundColor:AppColors.lightAccent,
    ));
  }

  void _handle(BuildContext context, String label)
  {
    final calc=context.read<CalculatorProvider>();
    final history=context.read<HistoryProvider>();
    switch (label) {
      case 'C':calc.clear();break;
      case 'CE':calc.delete();break;
      case '±':calc.toggleSign();break;
      case '=':
        calc.calculate();
        if(calc.result!='Error') history.addHistory(calc.expression,calc.result);
        break;
      default: calc.addToExpression(label);
    }
  }
}