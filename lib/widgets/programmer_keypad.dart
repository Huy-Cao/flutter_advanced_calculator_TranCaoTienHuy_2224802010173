import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import 'calculator_button.dart';
class ProgrammerKeypad extends StatelessWidget
{
  const ProgrammerKeypad({super.key});
  @override
  Widget build(BuildContext context)
  {
    final expr=context.select((CalculatorProvider p)=>p.expression);
    final isDark=Theme.of(context).brightness==Brightness.dark;
    final num=isDark?AppColors.btnNumberDark:AppColors.btnNumberLight;
    final fn=isDark?AppColors.btnFunctionDark:AppColors.btnFunctionLight;
    final op=AppColors.btnOperatorDark;
    final eq=AppColors.lightAccent;
    final numTxt=isDark?Colors.white:AppColors.textDark;
    final fnTxt=isDark?Colors.white:AppColors.textDark;
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal:8),
      child:Column(
        children: [
          _buildBaseStrip(context,expr),
          _buildRow(context,
              labels:['AND','OR','XOR','NOT','<<','>>'],
              colors:List.filled(6,fn),
              txtColors:List.filled(6,fnTxt)),
          _buildRow(context,
              labels:['A','B','7','8','9','÷'],
              colors:[fn,fn,num,num,num,op],
              txtColors:[fnTxt,fnTxt,numTxt,numTxt,numTxt,Colors.white]),
          _buildRow(context,
              labels:['C_HEX','D','4','5','6','×'],
              colors:[fn,fn,num,num,num,op],
              txtColors:[fnTxt, fnTxt, numTxt, numTxt, numTxt, Colors.white]),
          _buildRow(context,
              labels:['E','F','1','2','3','-'],
              colors:[fn,fn,num,num,num,op],
              txtColors:[fnTxt,fnTxt,numTxt,numTxt,numTxt,Colors.white]),
          _buildRow(context,
              labels:['CLR','CE','0','00','=','+'],
              colors:[fn,fn,num,num,eq,op],
              txtColors:[fnTxt,fnTxt,numTxt,numTxt,Colors.white,Colors.white]),
        ],
      ),
    );
  }
  Widget _buildBaseStrip(BuildContext context,String expr)
  {
    final isDark=Theme.of(context).brightness==Brightness.dark;
    final labelColor=isDark?AppColors.darkAccent:AppColors.lightAccent;
    final valueColor=isDark?Colors.white70:Colors.black87;
    String hexStr='-',decStr='-',octStr='-',binStr='-';
    try
    {
      final clean=expr.trim().replaceAll(RegExp(r'[^0-9a-fA-F]'),'');
      if(clean.isNotEmpty)
      {
        final val=int.parse(clean,radix:16);
        hexStr=val.toRadixString(16).toUpperCase();
        decStr=val.toString();
        octStr=val.toRadixString(8);
        binStr=val.toRadixString(2);
        if(binStr.length>12) binStr = '...${binStr.substring(binStr.length-12)}';
      }
    }
    catch(_) {}
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal:12,vertical:4),
      child:Row(
        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
        children: [
          _baseLabel('HEX',hexStr,labelColor,valueColor),
          _baseLabel('DEC',decStr,labelColor,valueColor),
          _baseLabel('OCT',octStr,labelColor,valueColor),
          _baseLabel('BIN',binStr,labelColor,valueColor),
        ],
      ),
    );
  }
  Widget _baseLabel(String base,String value,Color lc,Color vc)=>Column(
    children:[
      Text(base,style:TextStyle(color:lc,fontSize:10,fontWeight:FontWeight.bold)),
      Text(value,style:TextStyle(color:vc,fontSize:12)),
    ],
  );
  Widget _buildRow(BuildContext context,
  {
    required List<String>labels,
    required List<Color>colors,
    required List<Color>txtColors,
  }) {
    return Expanded(
      child:Row(
        children:List.generate(labels.length,(i)
        {
          final display=labels[i]=='C_HEX'?'C':labels[i];
          return CalculatorButton(
            text:display,
            bgColor:colors[i],
            textColor:txtColors[i],
            fontSize:labels[i].length>2?14:20,
            onTap:()=>_handle(context,labels[i]),
          );
        }),
      ),
    );
  }
  void _handle(BuildContext context,String label)
  {
    final calc=context.read<CalculatorProvider>();
    final history=context.read<HistoryProvider>();
    switch(label)
    {
      case 'CLR':calc.clear();break;
      case 'CE':calc.delete();break;
      case '=':
        calc.calculate();
        if(calc.result!='Error') history.addHistory(calc.expression,calc.result);
        break;
      case 'AND': case 'OR': case 'XOR': case 'NOT': case '<<': case '>>':
      calc.addToExpression(' $label ');
      break;
      case 'C_HEX':calc.addToExpression('C'); break;
      default:calc.addToExpression(label);
    }
  }
}