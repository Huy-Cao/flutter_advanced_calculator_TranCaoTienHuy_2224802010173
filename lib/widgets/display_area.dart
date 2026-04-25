import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../utils/constants.dart';
class DisplayArea extends StatefulWidget
{
  const DisplayArea({super.key});
  @override
  State<DisplayArea> createState()=>_DisplayAreaState();
}
class _DisplayAreaState extends State<DisplayArea> with TickerProviderStateMixin
{
  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  double _resultFontSize=60.0;
  double _baseFontSize=60.0;
  String _lastResult='0';
  @override
  void initState()
  {
    super.initState();
    _shakeCtrl=AnimationController(
      vsync:this,
      duration:const Duration(milliseconds:450),
    );
    _shakeAnim=TweenSequence<double>([
      TweenSequenceItem(tween:Tween(begin:0,end:-14),weight:1),
      TweenSequenceItem(tween:Tween(begin:-14,end:14),weight:2),
      TweenSequenceItem(tween:Tween(begin:14,end:-10),weight:2),
      TweenSequenceItem(tween:Tween(begin:-10,end:10),weight:2),
      TweenSequenceItem(tween:Tween(begin:10,end:0),weight:1),
    ]).animate(CurvedAnimation(parent:_shakeCtrl,curve:Curves.easeInOut));
    _fadeCtrl=AnimationController(
      vsync:this,
      duration:const Duration(milliseconds:300),
      value:1.0,
    );
    _fadeAnim=CurvedAnimation(parent:_fadeCtrl,curve:Curves.easeIn);
  }
  @override
  void dispose()
  {
    _shakeCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }
  void _triggerShake()
  {
    if(!mounted) return;
    _shakeCtrl..reset()..forward();
  }
  void _triggerFade()
  {
    if(!mounted) return;
    _fadeCtrl..reset()..forward();
  }
  @override
  Widget build(BuildContext context)
  {
    final isDark=Theme.of(context).brightness==Brightness.dark;
    final containerBg=isDark?AppColors.darkSecondary:AppColors.lightSecondary;
    final exprColor=isDark?Colors.white54:Colors.black45;
    final resultColor=isDark?AppColors.textWhite:AppColors.textDark;
    final dividerColor=isDark?Colors.white12:Colors.black12;
    final historyBg=isDark?Colors.white10:Colors.black.withOpacity(0.06);
    final historyBorder=isDark?Colors.white12:Colors.black12;
    final historyExpr=isDark?Colors.white38:Colors.black38;
    final historyRes=isDark?Colors.white70:Colors.black87;
    final badgeAccent=isDark?AppColors.darkAccent:AppColors.lightAccent;
    return Consumer2<CalculatorProvider,HistoryProvider>(
      builder:(context,calc,histProv, _)
      {
        if(calc.result!=_lastResult)
        {
          WidgetsBinding.instance.addPostFrameCallback((_)
          {
            if(!mounted) return;
            if(calc.result=='Error')
            {
              _triggerShake();
            }
            else
            {
              _triggerFade();
            }
            setState(()=>_lastResult=calc.result);
          });
        }
        final recentHistory=histProv.history.take(3).toList();
        return GestureDetector(
          onHorizontalDragEnd:(d)
          {
            if((d.primaryVelocity??0)>200) calc.delete();
          },
          onScaleStart:(_)=>_baseFontSize=_resultFontSize,
          onScaleUpdate:(d)
          {
            setState(()
            {
              _resultFontSize=(_baseFontSize*d.scale).clamp(28.0,80.0);
            });
          },
          child:Container(
            width:double.infinity,
            padding:const EdgeInsets.all(20),
            decoration:BoxDecoration(
              color:containerBg,
              borderRadius:BorderRadius.circular(24),
            ),
            child:Column(
              crossAxisAlignment:CrossAxisAlignment.end,
              children:[
                Row(
                  mainAxisAlignment:MainAxisAlignment.end,
                  children:[
                    if(calc.hasMemory) _badge('M',badgeAccent),
                    const SizedBox(width:6),
                    _badge(
                      calc.isRadianMode?'RAD':'DEG',
                      AppColors.lightAccent,
                    ),
                  ],
                ),
                const SizedBox(height:8),
                SingleChildScrollView(
                  scrollDirection:Axis.horizontal,
                  reverse:true,
                  child:Text(
                    calc.expression,
                    style:TextStyle(
                      color:exprColor,
                      fontSize:24,
                      fontFamily:'Roboto',
                    ),
                  ),
                ),
                const SizedBox(height:10),
                AnimatedBuilder(
                  animation:_shakeCtrl,
                  builder:(_,child)=>Transform.translate(
                    offset:Offset(_shakeAnim.value,0),
                    child:child,
                  ),
                  child:FadeTransition(
                    opacity:_fadeAnim,
                    child:FittedBox(
                      alignment:Alignment.centerRight,
                      fit:BoxFit.scaleDown,
                      child:Text(
                        calc.result,
                        style:TextStyle(
                          color:calc.result=='Error'
                              ?Colors.redAccent
                              :resultColor,
                          fontSize:_resultFontSize,
                          fontWeight:FontWeight.bold,
                          fontFamily:'Roboto',
                        ),
                      ),
                    ),
                  ),
                ),
                if(recentHistory.isNotEmpty) ...[
                  Divider(color:dividerColor,height:14),
                  SizedBox(
                    height:52,
                    child:ListView.separated(
                      scrollDirection:Axis.horizontal,
                      reverse:true,
                      itemCount:recentHistory.length,
                      separatorBuilder:(_, __)=>const SizedBox(width:8),
                      itemBuilder:(ctx,i)
                      {
                        final item=recentHistory[i];
                        return GestureDetector(
                          onTap:()=>calc.loadHistoryEntry(
                              item.expression,item.result),
                          child:Container(
                            padding:const EdgeInsets.symmetric(
                                horizontal:10,vertical:6),
                            decoration:BoxDecoration(
                              color:historyBg,
                              borderRadius:BorderRadius.circular(10),
                              border:Border.all(color:historyBorder),
                            ),
                            child:Column(
                              crossAxisAlignment:CrossAxisAlignment.end,
                              mainAxisSize:MainAxisSize.min,
                              children:[
                                Text(item.expression,
                                    style:TextStyle(
                                        color:historyExpr,fontSize:10),
                                    overflow:TextOverflow.ellipsis),
                                Text('= ${item.result}',
                                    style:TextStyle(
                                        color:historyRes,
                                        fontSize:13,
                                        fontWeight:FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _badge(String label,Color color)=>Container(
    padding:const EdgeInsets.symmetric(horizontal:8,vertical:2),
    decoration:BoxDecoration(
      color:color.withOpacity(0.2),
      borderRadius:BorderRadius.circular(6),
      border:Border.all(color:color.withOpacity(0.6)),
    ),
    child:Text(label,
        style:TextStyle(
            color:color,fontSize:12,fontWeight:FontWeight.bold)),
  );
}