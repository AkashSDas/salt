import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/recipe_editor.dart';
import 'package:salt/utils/recipe_editor.dart';
import 'package:salt/widgets/buttons/index.dart';
import 'package:salt/widgets/forms/regular_input_field.dart';

class IngredientForm extends StatelessWidget {
  const IngredientForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _p = Provider.of<RecipeEditorProvider>(context);

    return ChangeNotifierProvider(
      create: (context) => IngredientFormProvider(),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const _Header(),
            const SizedBox(height: 32),
            const _Form(),
            const SizedBox(height: 32),
            Builder(builder: (ctx) {
              final _iP = Provider.of<IngredientFormProvider>(ctx);

              return RoundedCornerButton(
                verticalPadding: 20,
                onPressed: () {
                  final ingredient = RecipeIngredient(
                    name: _iP.name,
                    description: _iP.description,
                    qunatity: _iP.quantity,
                  );

                  _p.addIngredient(ingredient);
                  Navigator.pop(context);
                },
                text: 'Add',
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IngredientFormProvider _p = Provider.of<IngredientFormProvider>(
      context,
    );

    return Column(
      children: [
        RegularInputField(
          label: 'Name',
          onChanged: (value) => _p.updateFormValue('name', value),
          hintText: 'Ingredient name',
        ),
        const SizedBox(height: 16),
        RegularInputField(
          label: 'Quantity',
          onChanged: (value) => _p.updateFormValue('quantity', value),
          hintText: "What's the quantity",
        ),
        const SizedBox(height: 16),
        RegularInputField(
          label: 'Description',
          onChanged: (value) => _p.updateFormValue('description', value),
          hintText: 'More details',
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add ingredient',
          style: DesignSystem.heading4.copyWith(fontSize: 20),
        ),
        SizedBox(
          width: 144,
          child: Expanded(
            child: RoundedCornerIconButton(
              icon: Icon(
                Icons.close_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.pop(context),
              text: 'Cancel',
            ),
          ),
        ),
      ],
    );
  }
}
