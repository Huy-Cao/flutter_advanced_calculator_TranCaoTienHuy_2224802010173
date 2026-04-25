import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../utils/constants.dart';
class ModeSelector extends StatelessWidget
{
  const ModeSelector({super.key});
  @override
  Widget build(BuildContext context)
  {
    final isDark=Theme.of(context).brightness==Brightness.dark;
    final bgColor=isDark ? AppColors.darkSecondary:AppColors.lightSecondary;
    final txtColor=isDark ? Colors.white:AppColors.textDark;
    return Consumer<CalculatorProvider>(
      builder:(context,provider,_)
      {
        return Row(
          mainAxisSize:MainAxisSize.min,
          children:[
            Container(
              padding:const EdgeInsets.symmetric(horizontal:12,vertical:4),
              decoration:BoxDecoration(
                color:bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child:DropdownButtonHideUnderline(
                child:DropdownButton<CalculatorMode>(
                  value:provider.mode,
                  dropdownColor:bgColor,
                  icon:Icon(Icons.keyboard_arrow_down,
                      color:AppColors.lightAccent),
                  style:TextStyle(color: txtColor, fontSize: 16),
                  items:CalculatorMode.values.map((mode)
                  {
                    return DropdownMenuItem<CalculatorMode>(
                      value:mode,
                      child:Text(
                        mode.name.toUpperCase(),
                        style:const TextStyle(fontWeight:FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  onChanged:(newMode)
                  {
                    if(newMode!=null) provider.toggleMode(newMode);
                  },
                ),
              ),
            ),
            if(provider.mode==CalculatorMode.scientific) ...[
              const SizedBox(width:8),
              GestureDetector(
                onTap:provider.toggleAngleMode,
                child:Container(
                  padding:const EdgeInsets.symmetric(
                      horizontal:10,vertical:6),
                  decoration:BoxDecoration(
                    color:bgColor,
                    borderRadius:BorderRadius.circular(10),
                    border:Border.all(
                      color:provider.isRadianMode
                          ?AppColors.darkAccent
                          :AppColors.lightAccent,
                      width:1.5,
                    ),
                  ),
                  child:Text(
                    provider.isRadianMode?'RAD':'DEG',
                    style:TextStyle(
                      color:provider.isRadianMode
                          ?AppColors.darkAccent
                          :AppColors.lightAccent,
                      fontSize:13,
                      fontWeight:FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}