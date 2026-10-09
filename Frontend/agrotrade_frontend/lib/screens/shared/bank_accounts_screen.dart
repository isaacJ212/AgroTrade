import 'package:flutter/material.dart';

import '../../models/api/bank_account_models.dart';
import '../../services/api_client.dart';
import '../../services/bank_account_api_service.dart';
import '../../ui/app_theme.dart';
import '../../ui/widgets/app_text_field.dart';

class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

class _BankAccountsScreenState extends State<BankAccountsScreen> {
  final _service = BankAccountApiService.instance;
  late Future<List<BankAccountDto>> _accountsFuture;

  @override
  void initState() {
    super.initState();
    _accountsFuture = _service.getAccounts();
  }

  void _reload() {
    setState(() {
      _accountsFuture = _service.getAccounts();
    });
  }

  Future<void> _openForm([BankAccountDto? account]) async {
    List<BankDto> banks;
    try {
      banks = await _service.getBanks();
    } catch (error) {
      if (mounted) _showMessage(_errorMessage(error));
      return;
    }

    if (!mounted) return;
    if (banks.isEmpty) {
      _showMessage('No hay bancos disponibles en este momento.');
      return;
    }

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _BankAccountFormDialog(
        banks: banks,
        account: account,
        service: _service,
      ),
    );
    if (saved == true && mounted) _reload();
  }

  Future<void> _delete(BankAccountDto account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar cuenta bancaria'),
        content: Text(
          'Se quitará la cuenta terminada en ${_lastDigits(account.numeroCuentaBancaria)} de tu perfil.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.errorColor,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _service.deleteAccount(account.idCuentaBancaria);
      if (!mounted) return;
      _reload();
      _showMessage('Cuenta bancaria eliminada.');
    } catch (error) {
      if (mounted) _showMessage(_errorMessage(error));
    }
  }

  String _lastDigits(String number) =>
      number.length <= 4 ? number : number.substring(number.length - 4);

  String _errorMessage(Object error) => error is ApiException
      ? error.message
      : 'Ocurrió un error. Intenta de nuevo.';

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text('Cuentas bancarias', style: AppTextStyles.Title),
        backgroundColor: AppColors.White,
        actions: [
          IconButton(
            tooltip: 'Agregar cuenta',
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add, color: AppColors.primaryColor),
          ),
        ],
      ),
      body: FutureBuilder<List<BankAccountDto>>(
        future: _accountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }
          if (snapshot.hasError) {
            return _EmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'No se pudieron cargar tus cuentas',
              actionLabel: 'Reintentar',
              onAction: _reload,
            );
          }

          final accounts = snapshot.data ?? const <BankAccountDto>[];
          if (accounts.isEmpty) {
            return _EmptyState(
              icon: Icons.account_balance_outlined,
              title: 'Aún no tienes cuentas bancarias',
              actionLabel: 'Agregar cuenta',
              onAction: () => _openForm(),
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryColor,
            onRefresh: () async => _reload(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              itemCount: accounts.length + 1,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${accounts.length} ${accounts.length == 1 ? 'cuenta registrada' : 'cuentas registradas'}',
                      style: AppTextStyles.SubTitle,
                    ),
                  );
                }
                final account = accounts[index - 1];
                return _AccountTile(
                  account: account,
                  maskedNumber:
                      '•••• ${_lastDigits(account.numeroCuentaBancaria)}',
                  onEdit: () => _openForm(account),
                  onDelete: () => _delete(account),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final BankAccountDto account;
  final String maskedNumber;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AccountTile({
    required this.account,
    required this.maskedNumber,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 8, 15),
      decoration: BoxDecoration(
        color: AppColors.White,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primarySoftBg,
            child: Icon(
              Icons.account_balance_outlined,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.nombreBanco, style: AppTextStyles.label),
                const SizedBox(height: 4),
                Text(maskedNumber, style: AppTextStyles.SubTitle),
                const SizedBox(height: 3),
                Text(account.titular, style: AppTextStyles.SubTitle),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Acciones de cuenta',
            onSelected: (action) => action == 'edit' ? onEdit() : onDelete(),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Editar')),
              PopupMenuItem(value: 'delete', child: Text('Eliminar')),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 46, color: AppColors.TextSoft),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.White,
              ),
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _BankAccountFormDialog extends StatefulWidget {
  final List<BankDto> banks;
  final BankAccountDto? account;
  final BankAccountApiService service;

  const _BankAccountFormDialog({
    required this.banks,
    required this.service,
    this.account,
  });

  @override
  State<_BankAccountFormDialog> createState() => _BankAccountFormDialogState();
}

class _BankAccountFormDialogState extends State<_BankAccountFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _numberController;
  late final TextEditingController _holderController;
  int? _bankId;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(
      text: widget.account?.numeroCuentaBancaria ?? '',
    );
    _holderController = TextEditingController(
      text: widget.account?.titular ?? '',
    );
    _bankId = widget.account?.idBanco;
  }

  @override
  void dispose() {
    _numberController.dispose();
    _holderController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _bankId == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final input = BankAccountInput(
      numeroCuentaBancaria: _numberController.text.trim(),
      idBanco: _bankId!,
      titular: _holderController.text.trim(),
    );
    try {
      final account = widget.account;
      if (account == null) {
        await widget.service.createAccount(input);
      } else {
        await widget.service.updateAccount(account.idCuentaBancaria, input);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = error is ApiException
            ? error.message
            : 'No se pudo guardar la cuenta. Intenta nuevamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.account != null;
    return Dialog(
      backgroundColor: AppColors.White,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primarySoftBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_balance_outlined,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isEditing ? 'Editar cuenta' : 'Agregar cuenta',
                          style: AppTextStyles.sectionTitle,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Cerrar',
                        onPressed: _saving
                            ? null
                            : () => Navigator.pop(context, false),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  DropdownButtonFormField<int>(
                    initialValue: _bankId,
                    decoration: appInputDecoration(label: 'Banco'),
                    dropdownColor: AppColors.White,
                    borderRadius: BorderRadius.circular(8),
                    items: widget.banks
                        .map(
                          (bank) => DropdownMenuItem(
                            value: bank.idBanco,
                            child: Text(bank.nombreBanco),
                          ),
                        )
                        .toList(),
                    onChanged: _saving
                        ? null
                        : (value) => setState(() => _bankId = value),
                    validator: (value) =>
                        value == null ? 'Selecciona un banco.' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numberController,
                    enabled: !_saving,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: appInputDecoration(
                      label: 'Número de cuenta',
                      hint: 'Ingresa el número de cuenta',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Ingresa el número de cuenta.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _holderController,
                    enabled: !_saving,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    decoration: appInputDecoration(
                      label: 'Titular de la cuenta',
                      hint: 'Nombre como aparece en el banco',
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Ingresa el nombre del titular.'
                        : null,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: AppColors.errorDark),
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _saving
                              ? null
                              : () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.TextMain,
                            side: const BorderSide(color: AppColors.cardBorder),
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _saving ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: AppColors.White,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _saving
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.White,
                                  ),
                                )
                              : Text(isEditing ? 'Guardar cambios' : 'Agregar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
