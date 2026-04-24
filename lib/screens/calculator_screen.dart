import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../models/calculator_mode.dart';
import '../widgets/basic_keypad.dart';
import '../widgets/programmer_keypad.dart';
import '../widgets/scientific_keypad.dart';
import '../widgets/mode_selector.dart';
import '../widgets/right_navigation.dart';
import '../widgets/display_area.dart';
import '../screens/history_screen.dart';
class CalculatorScreen extends StatelessWidget
{
  const CalculatorScreen({super.key});
  @override
  Widget build(BuildContext context)
  {
    final mode=context.select((CalculatorProvider p)=>p.mode);
    return Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      body:SafeArea(
        child: GestureDetector(
          onVerticalDragEnd:(details)
          {
            if((details.primaryVelocity ?? 0)<-400)
            {
              _openHistory(context);
            }
          },
          child:Column(
            children:[
              const Padding(
                padding:EdgeInsets.symmetric(horizontal:24,vertical:8),
                child:Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children:[
                    ModeSelector(),
                    RightNavigation(),
                  ],
                ),
              ),
              const Expanded(
                flex:35,
                child:Padding(
                  padding:EdgeInsets.symmetric(horizontal:24),
                  child:DisplayArea(),
                ),
              ),
              const SizedBox(height:12),
              Expanded(
                flex:65,
                child:AnimatedSwitcher(
                  duration:const Duration(milliseconds:300),
                  transitionBuilder:(child,anim)=>
                      FadeTransition(opacity:anim,child:child),
                  child:_keypad(mode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _keypad(CalculatorMode mode)
  {
    switch(mode)
    {
      case CalculatorMode.basic:
        return const BasicKeypad(key:ValueKey('basic'));
      case CalculatorMode.scientific:
        return const ScientificKeypad(key:ValueKey('scientific'));
      case CalculatorMode.programmer:
        return const ProgrammerKeypad(key:ValueKey('programmer'));
    }
  }
  static Future<void> _openHistory(BuildContext context) async
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
  static Future<void>openHistoryFrom(BuildContext context)=>_openHistory(context);
}
