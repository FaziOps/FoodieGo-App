import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PaymentGatewayType { stripeCard, googlePay, payPal, cashOnDelivery }

class PaymentMethodSelector extends StatefulWidget {
  final Function(PaymentGatewayType gateway, Map<String, String>? cardData) onPaymentMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.onPaymentMethodChanged,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  PaymentGatewayType _selectedGateway = PaymentGatewayType.stripeCard;

  final _cardNumberController = TextEditingController(text: '4242 4242 4242 4242');
  final _expiryController = TextEditingController(text: '12/28');
  final _cvcController = TextEditingController(text: '123');
  final _nameController = TextEditingController(text: 'Alex Johnson');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _notifyParent();
      }
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _notifyParent() {
    if (_selectedGateway == PaymentGatewayType.stripeCard) {
      widget.onPaymentMethodChanged(_selectedGateway, {
        'cardNumber': _cardNumberController.text.replaceAll(' ', ''),
        'expiry': _expiryController.text,
        'cvc': _cvcController.text,
        'name': _nameController.text,
      });
    } else {
      widget.onPaymentMethodChanged(_selectedGateway, null);
    }
  }

  void _fillTestCard() {
    setState(() {
      _cardNumberController.text = '4242 4242 4242 4242';
      _expiryController.text = '12/28';
      _cvcController.text = '123';
      _nameController.text = 'Alex Johnson';
    });
    _notifyParent();
  }

  String _getCardType(String number) {
    final clean = number.replaceAll(' ', '');
    if (clean.startsWith('4')) return 'VISA';
    if (clean.startsWith('5')) return 'MASTERCARD';
    if (clean.startsWith('3')) return 'AMEX';
    if (clean.startsWith('6')) return 'DISCOVER';
    return 'CARD';
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    const secondaryOrange = Color(0xFFE67E22);
    const darkInputFill = Color(0xFF1A1614);
    const creamText = Color(0xFFFDF5E6);

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: creamText.withValues(alpha: 0.7), fontSize: 14),
      prefixIcon: Icon(icon, color: secondaryOrange, size: 20),
      filled: true,
      fillColor: darkInputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: secondaryOrange, width: 1.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFD35400);
    const secondaryOrange = Color(0xFFE67E22);
    const darkSurface = Color(0xFF241E1C);
    const creamText = Color(0xFFFDF5E6);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.payment_rounded, color: secondaryOrange, size: 22),
              SizedBox(width: 10),
              Text(
                'Select Payment Gateway',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: creamText),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gateway Options Grid / Chips
          _buildGatewayTile(
            type: PaymentGatewayType.stripeCard,
            title: 'Credit / Debit Card',
            subtitle: 'Secured by Stripe Sandbox',
            icon: Icons.credit_card_rounded,
            badge: 'STRIPE',
            badgeColor: Colors.deepPurpleAccent,
          ),
          const SizedBox(height: 10),
          _buildGatewayTile(
            type: PaymentGatewayType.googlePay,
            title: 'Google Pay / Apple Pay',
            subtitle: 'Fast 1-Tap Express Payment',
            icon: Icons.phone_android_rounded,
            badge: 'EXPRESS',
            badgeColor: Colors.lightBlueAccent,
          ),
          const SizedBox(height: 10),
          _buildGatewayTile(
            type: PaymentGatewayType.payPal,
            title: 'PayPal / Wallet',
            subtitle: 'Pay via digital wallet account',
            icon: Icons.account_balance_wallet_rounded,
            badge: 'PAYPAL',
            badgeColor: Colors.indigoAccent,
          ),
          const SizedBox(height: 10),
          _buildGatewayTile(
            type: PaymentGatewayType.cashOnDelivery,
            title: 'Cash on Delivery (COD)',
            subtitle: 'Pay cash to rider upon food arrival',
            icon: Icons.local_atm_rounded,
            badge: 'COD',
            badgeColor: const Color(0xFF2ECC71),
          ),

          // Interactive Card Form if Stripe Card is Selected
          if (_selectedGateway == PaymentGatewayType.stripeCard) ...[
            const SizedBox(height: 24),
            const Divider(color: Colors.white12),
            const SizedBox(height: 16),

            // Visual Gradient Card Widget
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    primaryOrange,
                    secondaryOrange,
                    Color(0xFF1A1614),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryOrange.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.nfc_rounded, color: creamText, size: 28),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getCardType(_cardNumberController.text),
                          style: const TextStyle(
                            color: creamText,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _cardNumberController.text.isNotEmpty
                        ? _cardNumberController.text
                        : '•••• •••• •••• ••••',
                    style: const TextStyle(
                      color: creamText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARD HOLDER',
                            style: TextStyle(
                              color: creamText.withValues(alpha: 0.7),
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _nameController.text.isNotEmpty ? _nameController.text.toUpperCase() : 'YOUR NAME',
                            style: const TextStyle(
                              color: creamText,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'EXPIRES',
                            style: TextStyle(
                              color: creamText.withValues(alpha: 0.7),
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _expiryController.text.isNotEmpty ? _expiryController.text : 'MM/YY',
                            style: const TextStyle(
                              color: creamText,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Card Details', style: TextStyle(fontWeight: FontWeight.bold, color: creamText)),
                TextButton.icon(
                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                  onPressed: _fillTestCard,
                  icon: const Icon(Icons.bolt, size: 16, color: secondaryOrange),
                  label: const Text('Fill Test Card (4242)', style: TextStyle(fontSize: 12, color: secondaryOrange)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Card Number Input
            TextField(
              controller: _cardNumberController,
              style: const TextStyle(color: creamText),
              keyboardType: TextInputType.number,
              inputFormatters: [_CardNumberFormatter()],
              onChanged: (_) {
                setState(() {});
                _notifyParent();
              },
              decoration: _buildInputDecoration('Card Number', Icons.credit_card_rounded),
            ),
            const SizedBox(height: 12),

            // Expiry & CVC Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    style: const TextStyle(color: creamText),
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    inputFormatters: [_ExpiryFormatter()],
                    onChanged: (_) {
                      setState(() {});
                      _notifyParent();
                    },
                    decoration: _buildInputDecoration('Expires (MM/YY)', Icons.calendar_month_rounded).copyWith(counterText: ''),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvcController,
                    style: const TextStyle(color: creamText),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    onChanged: (_) {
                      setState(() {});
                      _notifyParent();
                    },
                    decoration: _buildInputDecoration('CVC / CVV', Icons.security_rounded).copyWith(counterText: ''),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Cardholder Name
            TextField(
              controller: _nameController,
              style: const TextStyle(color: creamText),
              onChanged: (_) {
                setState(() {});
                _notifyParent();
              },
              decoration: _buildInputDecoration('Cardholder Name', Icons.person_rounded),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGatewayTile({
    required PaymentGatewayType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badge,
    required Color badgeColor,
  }) {
    final isSelected = _selectedGateway == type;
    const secondaryOrange = Color(0xFFE67E22);
    const darkTileBg = Color(0xFF1A1614);
    const selectedTileBg = Color(0xFF3D251A);
    const creamText = Color(0xFFFDF5E6);

    return InkWell(
      onTap: () {
        setState(() => _selectedGateway = type);
        _notifyParent();
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isSelected ? selectedTileBg : darkTileBg,
          border: Border.all(
            color: isSelected ? secondaryOrange : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: secondaryOrange.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? secondaryOrange : creamText.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: secondaryOrange,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: isSelected ? secondaryOrange : creamText.withValues(alpha: 0.6), size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isSelected ? creamText : creamText.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: badgeColor.withValues(alpha: 0.4), width: 0.5),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: badgeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: creamText.withValues(alpha: 0.55)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) text = text.substring(0, 16);
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final nonOnlyDigits = i + 1;
      if (nonOnlyDigits % 4 == 0 && nonOnlyDigits != text.length) {
        buffer.write(' ');
      }
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i == 1 && text.length > 2) {
        buffer.write('/');
      }
    }
    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
