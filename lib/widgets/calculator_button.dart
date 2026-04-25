import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
class CalculatorButton extends StatefulWidget
{
  final String text;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final int flex;
  final double fontSize;
  const CalculatorButton({
    super.key,
    required this.text,
    required this.bgColor,
    required this.onTap,
    this.onLongPress,
    this.textColor=Colors.white,
    this.flex=1,
    this.fontSize=22,
  });
  @override
  State<CalculatorButton> createState()=>_CalculatorButtonState();
}
class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin
{
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  @override
  void initState()
  {
    super.initState();
    _ctrl=AnimationController(
      vsync:this,
      duration:const Duration(milliseconds:200),
    );
    _scale=Tween<double>(begin:1.0,end:0.88).animate(
      CurvedAnimation(parent:_ctrl,curve:Curves.easeInOut),
    );
  }
  @override
  void dispose()
  {
    _ctrl.dispose();
    super.dispose();
  }
  Future<void> _onTapDown(TapDownDetails _) async
  {
    _ctrl.forward();
    final settings=context.read<ThemeProvider>().settings;
    if(settings.hapticFeedback)
    {
      await HapticFeedback.lightImpact();
    }
    if(settings.soundEffects)
    {
      await SystemSound.play(SystemSoundType.click);
      if(context.mounted) await Feedback.forTap(context);
    }
  }
  void _onTapUp(TapUpDetails _)
  {
    _ctrl.reverse();
    widget.onTap();
  }
  void _onTapCancel()=>_ctrl.reverse();
  @override
  Widget build(BuildContext context)
  {
    return Expanded(
      flex:widget.flex,
      child:GestureDetector(
        onTapDown:_onTapDown,
        onTapUp:_onTapUp,
        onTapCancel:_onTapCancel,
        onLongPress:widget.onLongPress,
        child:AnimatedBuilder(
          animation:_scale,
          builder:(_,child)=>Transform.scale(
            scale:_scale.value,
            child:child,
          ),
          child:Padding(
            padding:const EdgeInsets.all(6.0),
            child:Container(
              height:double.infinity,
              alignment:Alignment.center,
              decoration:BoxDecoration(
                color:widget.bgColor,
                borderRadius:BorderRadius.circular(16),
              ),
              child:Text(
                widget.text,
                style:TextStyle(
                  color:widget.textColor,
                  fontSize:widget.fontSize,
                  fontFamily:'Roboto',
                  fontWeight:FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}