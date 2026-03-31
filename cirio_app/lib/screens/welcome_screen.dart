import 'package:cirio_app/data/app_theme.dart';
import 'package:cirio_app/screens/map_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                BoxShadow(
                  color: AppTheme.onSurface.withValues(alpha: 0.04),
                  blurRadius: 32
                )
              ]
              ),
              child: Icon(
                Icons.church,
                size: 60,
                color: AppTheme.primary,
              ),
            ),
            SizedBox(height: 32),
            Text(
              "Bem-vindo ao\nCírio de Nazaré",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary
              ),              
            ),
            SizedBox(height: 16),
            Text(
              "Vivencie a maior manifestação de fé do\nmundo na palma da sua mão.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.onSurface
              ),              
            ),
            SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              }, 
              child: Text("Começar  →", style: TextStyle(fontSize: 16),)
            )
          ]
        ),
      ),
    );
  }

}