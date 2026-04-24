import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_settings.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
class SettingsScreen extends StatefulWidget
{
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen>createState()=>_SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen>
{
  late CalculatorSettings _local;
  @override
  void initState()
  {
    super.initState();
    _local=context.read<ThemeProvider>().settings;
  }
  bool _isDark(BuildContext ctx)=>Theme.of(ctx).brightness==Brightness.dark;
  Color _cardColor(BuildContext ctx)=>_isDark(ctx)?AppColors.darkSecondary:AppColors.lightSecondary;
  Color _titleColor(BuildContext ctx)=>_isDark(ctx)?Colors.white:AppColors.textDark;
  Color _subtitleColor(BuildContext ctx)=>_isDark(ctx)?Colors.grey:Colors.black54;
  Color _iconColor(BuildContext ctx)=>_isDark(ctx)?Colors.white70:Colors.black54;
  @override
  Widget build(BuildContext context)
  {
    final theme=Theme.of(context);
    final isDark=_isDark(context);
    return Scaffold(
      backgroundColor:theme.scaffoldBackgroundColor,
      appBar:AppBar(
        backgroundColor:theme.scaffoldBackgroundColor,
        elevation:0,
        title:Text('Settings',
            style:TextStyle(
              color:isDark?Colors.white:AppColors.textDark,
              fontWeight:FontWeight.w600,
            )),
        leading:IconButton(
          icon:Icon(Icons.arrow_back_ios,
              color:isDark?Colors.white:AppColors.textDark),
          onPressed:()=>Navigator.pop(context),
        ),
      ),
      body:ListView(
        padding:const EdgeInsets.all(24),
        children:[
          _sectionHeader(context,'Appearance'),
          _themeModeSelector(context),
          const SizedBox(height:24),
          _sectionHeader(context,'Calculation'),
          _switchTile(
            context,
            title:'Radian Mode',
            subtitle:'Off = Degrees, On = Radians',
            value:_local.isRadianMode,
            icon:Icons.rotate_right_outlined,
            onChanged:(v)
            {
              _update(_local.copyWith(isRadianMode:v));
              final calc=context.read<CalculatorProvider>();
              if(calc.isRadianMode!=v)
                calc.toggleAngleMode();
            },
          ),
          _decimalSlider(context),
          const SizedBox(height:24),
          _sectionHeader(context,'System'),
          _switchTile(
            context,
            title:'Haptic Feedback',
            subtitle:'Vibrate on button press',
            value:_local.hapticFeedback,
            icon:Icons.feedback_outlined,
            onChanged:(v)=>_update(_local.copyWith(hapticFeedback: v)),
          ),
          _switchTile(
            context,
            title:'Sound Effects',
            subtitle:'Play click sound on button press',
            value:_local.soundEffects,
            icon:Icons.volume_up_outlined,
            onChanged:(v)=>_update(_local.copyWith(soundEffects:v)),
          ),
          const SizedBox(height:24),
          _sectionHeader(context,'History'),
          _historySize(context),
          const SizedBox(height:8),
          _clearHistoryTile(context),
        ],
      ),
    );
  }
  Widget _themeModeSelector(BuildContext context)
  {
    const options=[
      {'label':'Light','value':'light','icon':Icons.light_mode_outlined},
      {'label':'Dark','value':'dark','icon':Icons.dark_mode_outlined},
      {'label':'System','value':'system','icon':Icons.brightness_auto_outlined},
    ];
    final cardColor=_cardColor(context);
    final titleColor=_titleColor(context);
    final iconColor=_iconColor(context);
    return Container(
      margin:const EdgeInsets.only(bottom:8),
      decoration:BoxDecoration(
        color:cardColor,
        borderRadius:BorderRadius.circular(12),
      ),
      child:Column(
        children:options.map((opt)
        {
          final val=opt['value'] as String;
          final label=opt['label'] as String;
          final icon=opt['icon']  as IconData;
          final selected=_local.themeModeSetting==val;
          return RadioListTile<String>(
            activeColor:AppColors.lightAccent,
            secondary:Icon(icon,
                color:selected?AppColors.lightAccent:iconColor),
            title:Text(label, style: TextStyle(color: titleColor)),
            value:val,
            groupValue:_local.themeModeSetting,
            onChanged:(v)
            {
              if(v!=null)
                _update(_local.copyWith(themeModeSetting:v));
            },
          );
        }).toList(),
      ),
    );
  }
  void _update(CalculatorSettings updated)
  {
    setState(()=>_local=updated);
    context.read<ThemeProvider>().updateSettings(updated);
    context.read<HistoryProvider>().setMaxSize(updated.historySize);
    context.read<CalculatorProvider>().setDecimalPrecision(updated.decimalPrecision);
  }
  Widget _sectionHeader(BuildContext context,String title)=>Padding(
    padding:const EdgeInsets.only(bottom:12,left:4),
    child:Text(
      title.toUpperCase(),
      style:const TextStyle(
        color:AppColors.lightAccent,
        fontSize:13,
        fontWeight:FontWeight.bold,
        letterSpacing:1.2,
      ),
    ),
  );
  Widget _switchTile(
      BuildContext context,
      {
        required String title,
        String? subtitle,
        required bool value,
        required IconData icon,
        required ValueChanged<bool>onChanged,
      }) {
    final cardColor=_cardColor(context);
    final titleColor=_titleColor(context);
    final subtitleColor=_subtitleColor(context);
    final iconColor=_iconColor(context);
    return Container(
      margin:const EdgeInsets.only(bottom:8),
      decoration:BoxDecoration(
        color:cardColor,
        borderRadius:BorderRadius.circular(12),
      ),
      child:SwitchListTile(
        activeColor:AppColors.lightAccent,
        secondary:Icon(icon,color:iconColor),
        title:Text(title,style:TextStyle(color:titleColor)),
        subtitle:subtitle!=null
            ? Text(subtitle,style:TextStyle(color:subtitleColor,fontSize:12))
            : null,
        value:value,
        onChanged:onChanged,
      ),
    );
  }
  Widget _decimalSlider(BuildContext context)
  {
    final cardColor=_cardColor(context);
    final titleColor=_titleColor(context);
    return Container(
      margin:const EdgeInsets.only(bottom:8),
      padding:const EdgeInsets.symmetric(horizontal:16,vertical:12),
      decoration:BoxDecoration(
        color:cardColor,
        borderRadius:BorderRadius.circular(12),
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children:[
              Text('Decimal Precision',
                  style:TextStyle(color:titleColor,fontSize:16)),
              Text('${_local.decimalPrecision}digits',
                  style:const TextStyle(
                      color:AppColors.lightAccent,fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value:_local.decimalPrecision.toDouble(),
            min:2,
            max:10,
            divisions:8,
            activeColor:AppColors.lightAccent,
            inactiveColor:_isDark(context)
                ? AppColors.darkPrimary
                : AppColors.lightSecondary.withOpacity(0.5),
            onChanged: (v) => _update(_local.copyWith(decimalPrecision: v.toInt())),
          ),
        ],
      ),
    );
  }
  Widget _historySize(BuildContext context)
  {
    final cardColor=_cardColor(context);
    final titleColor=_titleColor(context);
    return Container(
      margin:const EdgeInsets.only(bottom: 8),
      decoration:BoxDecoration(
        color:cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [25,50,100].map((size)
        {
          return RadioListTile<int>(
            activeColor:AppColors.lightAccent,
            title:Text('$size calculations',
                style: TextStyle(color: titleColor)),
            value:size,
            groupValue: _local.historySize,
            onChanged:  (v) => _update(_local.copyWith(historySize: v)),
          );
        }).toList(),
      ),
    );
  }
  Widget _clearHistoryTile(BuildContext context)
  {
    final cardColor=_cardColor(context);
    return Container(
      decoration:BoxDecoration(
        color:cardColor,
        borderRadius:BorderRadius.circular(12),
      ),
      child:ListTile(
        onTap:()=>_showClearDialog(context),
        leading:Container(
          padding:const EdgeInsets.all(8),
          decoration:BoxDecoration(
            color:Colors.red.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child:const Icon(Icons.delete_forever,color:Colors.red),
        ),
        title:const Text('Clear All History',
            style:TextStyle(color: Colors.red,fontWeight:FontWeight.bold)),
        subtitle:Text('Permanently delete all calculation history',
            style:TextStyle(color: _subtitleColor(context))),
      ),
    );
  }
  void _showClearDialog(BuildContext context)
  {
    final cardColor=_cardColor(context);
    final titleColor=_titleColor(context);
    showDialog(
      context:context,
      builder:(ctx)=>AlertDialog(
        backgroundColor:cardColor,
        title:Text('Clear History?', style:TextStyle(color:titleColor)),
        content:Text('All history will be deleted. This cannot be undone.',
            style:TextStyle(color: _subtitleColor(context))),
        actions: [
          TextButton(
            onPressed:()=>Navigator.pop(ctx),
            child:const Text('Cancel',style:TextStyle(color:Colors.white54)),
          ),
          TextButton(
            onPressed:()
            {
              context.read<HistoryProvider>().clearHistory();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:Text('History cleared'),
                  backgroundColor:AppColors.lightAccent,
                  duration:Duration(seconds:1),
                ),
              );
            },
            child:const Text('Delete',style:TextStyle(color:Colors.red)),
          ),
        ],
      ),
    );
  }
}