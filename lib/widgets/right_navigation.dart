import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';
class RightNavigation extends StatelessWidget
{
  const RightNavigation({super.key});
  @override
  Widget build(BuildContext context)
  {
    final isDark=Theme.of(context).brightness==Brightness.dark;
    final bgColor=isDark ? AppColors.darkSecondary:AppColors.lightSecondary;
    final iconColor=isDark ? Colors.white70:Colors.black54;
    return Container(
      decoration:BoxDecoration(
        color:bgColor,
        borderRadius:BorderRadius.circular(12),
      ),
      child:Row(
        mainAxisSize:MainAxisSize.min,
        children:[
          _iconButton(
            context,
            icon:Icons.history,
            color:iconColor,
            onTap:()=>_openHistory(context),
          ),
          _divider(isDark),
          _iconButton(
            context,
            icon:Icons.delete_sweep_outlined,
            color:AppColors.lightAccent,
            onTap:()
            {
              Provider.of<HistoryProvider>(context,listen:false).clearHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:Text('History cleared'),
                  duration:Duration(milliseconds:500),
                ),
              );
            },
          ),
          _divider(isDark),
          _iconButton(
            context,
            icon:Icons.settings_outlined,
            color:iconColor,
            onTap:()=>Navigator.push(
              context,
              MaterialPageRoute(builder:(_)=>const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }
  void _openHistory(BuildContext context) async
  {
    final data=await Navigator.push<HistorySelection>(
      context,
      MaterialPageRoute(builder:(_)=>const HistoryScreen()),
    );
    if(data!=null&&context.mounted)
    {
      context.read<CalculatorProvider>().loadHistoryEntry(
        data['expression']!,
        data['result']!,
      );
    }
  }
  Widget _divider(bool isDark)=>Container(
    height:20,
    width:1,
    color:isDark
        ?Colors.grey.withOpacity(0.3)
        :Colors.black.withOpacity(0.12),
  );
  Widget _iconButton(
      BuildContext context,
      {
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Material(
      color:Colors.transparent,
      child:InkWell(
        borderRadius:BorderRadius.circular(12),
        onTap:onTap,
        child:Padding(
          padding:const EdgeInsets.symmetric(horizontal:16,vertical:12),
          child:Icon(icon,size:22,color:color),
        ),
      ),
    );
  }
}