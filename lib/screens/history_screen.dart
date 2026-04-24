import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../utils/constants.dart';
typedef HistorySelection = Map<String,String>;
class HistoryScreen extends StatelessWidget
{
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context)
  {
    final historyList=context.watch<HistoryProvider>().history;
    final isDark=Theme.of(context).brightness==Brightness.dark;
    final bgColor=isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final cardColor=isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
    final exprColor=isDark ? Colors.white70 : Colors.black54;
    final timeColor=isDark ? Colors.grey : Colors.black38;
    return Scaffold(
      backgroundColor:bgColor,
      appBar:AppBar(
        backgroundColor:bgColor,
        elevation:0,
        title:Text('History',
            style:TextStyle(
              color:isDark ? Colors.white:AppColors.textDark,
              fontWeight:FontWeight.w600,
            )),
        leading:IconButton(
          icon:Icon(Icons.arrow_back_ios,
              color:isDark ? Colors.white : AppColors.textDark),
          onPressed:()=>Navigator.pop(context),
        ),
        actions:[
          IconButton(
            icon:const Icon(Icons.delete_sweep_outlined,
                color:AppColors.lightAccent),
            onPressed:()=>_confirmClear(context, cardColor, isDark),
          ),
        ],
      ),
      body:historyList.isEmpty
          ? Center(
        child:Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children:[
            Icon(Icons.history,
                size:64,
                color:isDark ? Colors.grey[700] : Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No history yet',
                style:TextStyle(
                  color:isDark ? Colors.white54 : Colors.black38,
                  fontSize:18,
                )),
          ],
        ),
      )
          :ListView.separated(
        padding:const EdgeInsets.all(16),
        itemCount:historyList.length,
        separatorBuilder:(_, __)=>const SizedBox(height: 12),
        itemBuilder:(context,index)
        {
          final item=historyList[index];
          return Dismissible(
            key:ValueKey(item.timestamp),
            direction:DismissDirection.endToStart,
            background:Container(
              alignment:Alignment.centerRight,
              padding:const EdgeInsets.only(right:20),
              decoration:BoxDecoration(
                color:Colors.red,
                borderRadius:BorderRadius.circular(16),
              ),
              child:const Icon(Icons.delete,color:Colors.white),
            ),
            onDismissed:(_)=>
                context.read<HistoryProvider>().removeItem(index),
            child:InkWell(
              borderRadius:BorderRadius.circular(16),
              onTap:()=>Navigator.pop<HistorySelection>(
                context,
                {'expression':item.expression,'result':item.result},
              ),
              child:Container(
                decoration:BoxDecoration(
                  color:cardColor,
                  borderRadius:BorderRadius.circular(16),
                ),
                child:ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal:20,vertical:8),
                  trailing:Icon(Icons.keyboard_return,
                      size:16,
                      color:isDark ? Colors.white24:Colors.black26),
                  title:Align(
                    alignment:Alignment.centerRight,
                    child:Text(item.expression,
                        style:TextStyle(
                          color:exprColor,
                          fontSize:18,
                          fontFamily:'Roboto',
                          fontWeight:FontWeight.w300,
                        )),
                  ),
                  subtitle:Column(
                    crossAxisAlignment:CrossAxisAlignment.end,
                    children:[
                      Text('=${item.result}',
                          style:const TextStyle(
                            color:AppColors.lightAccent,
                            fontSize:28,
                            fontWeight:FontWeight.bold,
                          )),
                      const SizedBox(height:4),
                      Text(
                        DateFormat('HH:mm dd/MM').format(item.timestamp),
                        style:TextStyle(color:timeColor,fontSize:12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  void _confirmClear(BuildContext context,Color cardColor,bool isDark)
  {
    showDialog(
      context:context,
      builder:(ctx)=>AlertDialog(
        backgroundColor:cardColor,
        title:Text('Clear History?',
            style:TextStyle(color: isDark ? Colors.white:AppColors.textDark)),
        content:Text('All calculation history will be deleted permanently.',
            style:TextStyle(
                color:isDark ? Colors.white70 : Colors.black54)),
        actions:[
          TextButton(
            onPressed:()=>Navigator.pop(ctx),
            child:const Text('Cancel',
                style:TextStyle(color:Colors.white54)),
          ),
          TextButton(
            onPressed:()
            {
              context.read<HistoryProvider>().clearHistory();
              Navigator.pop(ctx);
            },
            child:const Text('Delete',
                style:TextStyle(color:Colors.red)),
          ),
        ],
      ),
    );
  }
}
