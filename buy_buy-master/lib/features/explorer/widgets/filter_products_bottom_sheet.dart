import 'package:auto_route/auto_route.dart';
import 'package:buy_buy/features/explorer/bloc/bloc.dart';
import 'package:buy_buy/models/models.dart';
import 'package:buy_buy/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterProductsBottomSheet extends StatefulWidget {
  final ProductFilter? initialFilter;

  const FilterProductsBottomSheet({super.key, this.initialFilter});

  @override
  State<FilterProductsBottomSheet> createState() => _FilterProductsBottomSheetState();
}

class _FilterProductsBottomSheetState extends State<FilterProductsBottomSheet> {
  late String? _selectedBrandId;
  late bool? _selectedIsBrandNew;

  @override
  void initState() {
    super.initState();
    _selectedBrandId = widget.initialFilter?.brandId;
    _selectedIsBrandNew = widget.initialFilter?.isBrandNew;

    context.read<BrandBloc>().add(BrandLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('Filter Products', style: theme.textTheme.titleLarge)),
            const SizedBox(height: 16),
            Text('Brand filter', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            BlocBuilder<BrandBloc, BrandState>(
              builder: (context, state) {
                if (state is BrandLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BrandLoaded) {
                  return DropdownButton<String?>(
                    isExpanded: true,
                    value: _selectedBrandId,
                    hint: const Text('All Brands'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ...state.brands.map((b) => DropdownMenuItem(value: b.id, child: Text(b.name))),
                    ],
                    onChanged: _onBrandSelected,
                  );
                } else {
                  return const Text('Error loading brands');
                }
              },
            ),
            const SizedBox(height: 24),
            Text('Brand New filter', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
            RadioListTile<bool?>(
              title: Text('All', style: theme.textTheme.labelLarge),
              value: null,
              groupValue: _selectedIsBrandNew,
              onChanged: _onIsBrandNewSelected,
            ),
            RadioListTile<bool?>(
              title: Text('Brand New', style: theme.textTheme.labelLarge),
              value: true,
              groupValue: _selectedIsBrandNew,
              onChanged: _onIsBrandNewSelected,
            ),
            RadioListTile<bool?>(
              title: Text('Second Hand', style: theme.textTheme.labelLarge),
              value: false,
              groupValue: _selectedIsBrandNew,
              onChanged: _onIsBrandNewSelected,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: _onCancel,
                  child: Text('Cancel', style: theme.textTheme.titleMedium?.copyWith(color: Colors.red)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _onApply, child: Text('Apply', style: theme.textTheme.titleMedium)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _onBrandSelected(String? brandId) {
    setState(() {
      _selectedBrandId = brandId;
    });
  }

  _onIsBrandNewSelected(bool? isBrandNew) {
    setState(() {
      _selectedIsBrandNew = isBrandNew;
    });
  }

  _onApply() {
    final ProductFilter filter = ProductFilter(brandId: _selectedBrandId, isBrandNew: _selectedIsBrandNew);
    context.router.maybePop(filter);
  }

  _onCancel() {
    context.router.maybePop(null);
  }
}
