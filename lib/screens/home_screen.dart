import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project_app/utils/colors.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientMid,
              AppColors.gradientEnd,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 24),
              _buildBalanceSection(),
              SizedBox(height: 32),
              _buildActionButtons(),
              SizedBox(height: 24),
              Expanded(
                child: _buildTransactionCard(),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey Daud',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: '.SF Pro Text',
                ),
              ),
              Text(
                'Welcome Back !',
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: '.SF Pro Display',
                ),
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.iconBackground,
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.primaryText,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Column(
      children: [
        Text(
          'TOTAL BALANCE',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
            fontFamily: '.SF Pro Text',
          ),
        ),
        SizedBox(height: 8),
        Text(
          '2,8454.32\$',
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            fontFamily: '.SF Pro Display',
          ),
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.buttonBorder, width: 1),
            color: AppColors.iconBackground.withOpacity(0.5),
          ),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Holdings',
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: '.SF Pro Text',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(Icons.call_received_rounded, 'Receive'),
          _buildActionButton(Icons.call_made_rounded, 'Send'),
          _buildActionButton(Icons.swap_vert_rounded, 'Swap'),
          _buildActionButton(Icons.access_time_rounded, 'Earn'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.iconBackground,
          ),
          child: Icon(icon, color: AppColors.primaryText, size: 26),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontFamily: '.SF Pro Text',
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            _buildTransactionItem(
              spotifyWidget(),
              'IBAN Deposit',
              '2:14 PM',
              '+1,200.00 \$',
              AppColors.positiveAmount,
              showDivider: true,
            ),
            _buildTransactionItem(
              starbucksWidget(),
              'SPOT',
              '2:14 PM',
              '-9.99 \$',
              AppColors.negativeAmount,
              showDivider: true,
            ),
            _buildTransactionItem(
              aaplWidget(),
              'Bough AAPL',
              '2:14 PM',
              '-150.00 \$',
              AppColors.negativeAmount,
              showDivider: false,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.accentBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: '.SF Pro Text',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget spotifyWidget() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1DB954),
      ),
      child: Center(
        child: Icon(Icons.music_note_rounded, color: Colors.white, size: 22),
      ),
    );
  }

  Widget starbucksWidget() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF00704A),
      ),
      child: Center(
        child: Icon(Icons.local_cafe_rounded, color: Colors.white, size: 22),
      ),
    );
  }

  Widget aaplWidget() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2C2C2E),
        border: Border.all(color: Color(0xFF3A3A3C), width: 1),
      ),
      child: Center(
        child: Icon(Icons.show_chart_rounded, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildTransactionItem(
    Widget iconWidget,
    String title,
    String time,
    String amount,
    Color amountColor, {
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              iconWidget,
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: '.SF Pro Text',
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      time,
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: '.SF Pro Text',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  color: amountColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: '.SF Pro Text',
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.buttonBorder,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bottomNavBackground,
        border: Border(
          top: BorderSide(color: AppColors.buttonBorder, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.show_chart_rounded, 'Invest', 1),
              _buildNavItem(Icons.account_balance_wallet_rounded, 'Wallet', 2),
              _buildNavItem(Icons.settings_rounded, 'Settings', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.iconBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.selectedNavItem : AppColors.unselectedNavItem,
              size: 24,
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.selectedNavItem : AppColors.unselectedNavItem,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontFamily: '.SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
}