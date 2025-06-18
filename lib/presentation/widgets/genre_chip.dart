import 'package:flutter/material.dart';
import '../../core/theme.dart';

class GenreChip extends StatelessWidget {
  final String genre;
  
  final bool isSelected;
  final VoidCallback onTap;

  const GenreChip({
    super.key,
    required this.genre,
    
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Chip(
          label: Text(genre),
          
          backgroundColor: isSelected ? AppTheme.primaryAccent : AppTheme.primarySurface,
          labelStyle: const TextStyle(color: AppTheme.textColor),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected ? AppTheme.primaryAccent : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}