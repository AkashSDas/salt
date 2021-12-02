import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salt/design_system.dart';
import 'package:salt/providers/recipe_editor.dart';

class IngredientTable extends StatelessWidget {
  IngredientTable({Key? key}) : super(key: key);

  final TextStyle? _bodyTextStyle = DesignSystem.caption.copyWith(
    fontWeight: FontWeight.w400,
  );

  final TextStyle? _headingTextStyle = DesignSystem.caption.copyWith(
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    RecipeEditorProvider _p = Provider.of<RecipeEditorProvider>(context);

    return SizedBox(
      height: _p.tableHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          DataTable(
            dataRowHeight: 44,
            decoration: BoxDecoration(
              color: DesignSystem.gallery,
              borderRadius: BorderRadius.circular(16),
            ),
            columns: [
              DataColumn(label: Text('Remove', style: _headingTextStyle)),
              DataColumn(label: Text('Ingredient', style: _headingTextStyle)),
              DataColumn(label: Text('Quantity', style: _headingTextStyle)),
              DataColumn(label: Text('Description', style: _headingTextStyle)),
            ],
            rows: List.generate(
              _p.ingredients.length,
              (idx) => DataRow(
                cells: [
                  DataCell(
                    TextButton(
                      onPressed: () => _p.removeIngredient(idx),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: DesignSystem.tundora),
                        ),
                        child: const FlareActor(
                          'assets/flare-icons/remove.flr',
                          animation: 'idle',
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text(
                    _p.ingredients[idx].name,
                    style: _bodyTextStyle,
                  )),
                  DataCell(Text(
                    _p.ingredients[idx].qunatity,
                    style: _bodyTextStyle,
                  )),
                  DataCell(Text(
                    _p.ingredients[idx].description,
                    style: _bodyTextStyle,
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
