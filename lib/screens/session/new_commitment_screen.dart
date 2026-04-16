import 'package:commitlock/components/customdropdown.dart';
import 'package:commitlock/core/constants/app_theme.dart';
import 'package:commitlock/core/utils/validators.dart';
import 'package:commitlock/providers/auth_provider.dart';
import 'package:commitlock/providers/session_provider.dart';
import 'package:commitlock/screens/session/active_session_screen.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:provider/provider.dart';

class NewCommitmentScreen extends StatefulWidget {
  const NewCommitmentScreen({super.key});

  @override
  State<NewCommitmentScreen> createState() => _NewCommitmentScreenState();
}

class _NewCommitmentScreenState extends State<NewCommitmentScreen> {
  String? selectedCategory;
  String? selectedDuration;
  String? selectedRestrictionLevel;
  String? selectedBlockedApp;

  bool _isLoading = false;

  final TextEditingController customCategoryController =
      TextEditingController();

  final TextEditingController penaltyAmountController = TextEditingController();
  final TextEditingController customDurationController =
      TextEditingController();
  final TextEditingController customRestrictionController =
      TextEditingController();

  final MultiSelectController<String> blockedAppsController =
      MultiSelectController<String>();

  final _formKey = GlobalKey<FormState>();

  bool isCustomCategory = false;

  final habitCategory = [
    "Coding Practice",
    "Exercise",
    "Reading",
    "Meditation",
    "Language",
    "custom",
  ];
  final duration = ["15", "30", "45", "60", "90", "custom"];

  final restrictionLevels = ["Normal", "Strict", "Extreme"];

  final blockedApps = ["Social Media", "Gaming", "Video Streaming"];
  List<DropdownItem<String>> get blockedAppItems =>
      blockedApps.map((app) => DropdownItem(label: app, value: app)).toList();

  @override
  void dispose() {
    customCategoryController.dispose();
    penaltyAmountController.dispose();
    selectedBlockedApp = null;
    selectedRestrictionLevel = null;
    selectedDuration = null;
    selectedCategory = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).currentUser?.id ?? "default_user";
    return Scaffold(
      appBar: AppBar(title: const Text("Add Commitment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomDropdownWithInput(
                  validator: Validators.emptyValidator,
                  items: habitCategory,
                  value: selectedCategory,
                  label: "Habit Category",
                  customLabel: "Custom Category",
                  controller: customCategoryController,
                  itemLabel: (item) => item == "custom" ? "➕ Custom" : item,
                  onChanged: (value, customValue) {
                    setState(() {
                      selectedCategory = value == "custom"
                          ? customValue
                          : value;
                    });
                  },
                ),

                const SizedBox(height: 12),

                CustomDropdownWithInput(
                  validator: Validators.integerValidator,
                  isNum: true,
                  items: duration,
                  value: selectedDuration,
                  label: "Duration (minutes)",
                  customLabel: "Custom Duration",
                  controller: customDurationController,
                  itemLabel: (item) => item == "custom" ? "➕ Custom" : item,
                  onChanged: (value, customValue) {
                    setState(() {
                      selectedDuration = value == "custom"
                          ? customValue
                          : value;
                    });
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: penaltyAmountController,
                  keyboardType: TextInputType.number,
                  validator: Validators.doubleValidator,

                  decoration: InputDecoration(
                    hintText: 'Penalty Amount',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.accentColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.dangerColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.dangerColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.secondaryColor,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomDropdownWithInput(
                  validator: Validators.emptyValidator,
                  items: restrictionLevels,
                  value: selectedRestrictionLevel,
                  label: "Restriction Level",
                  customLabel: "",
                  controller: customRestrictionController,
                  itemLabel: (item) => item,
                  onChanged: (value, customValue) {
                    // Handle restriction level change
                    setState(() {
                      selectedRestrictionLevel = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                MultiDropdown<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select at least one blocked app';
                    }
                    return null;
                  },
                  items: blockedAppItems,
                  controller: blockedAppsController,
                  enabled: true,
                  searchEnabled: false,
                  chipDecoration: ChipDecoration(
                    backgroundColor: AppColors.secondaryColor,
                    wrap: true,
                  ),
                  fieldDecoration: FieldDecoration(
                    backgroundColor: Colors.grey.shade100,
                    hintText: 'Select Blocked Apps',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.subTextColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.dangerColor,
                      ),
                    ),
                  ),
                  dropdownDecoration: DropdownDecoration(maxHeight: 300),
                  // onSelectionChange: (selectedItems) {
                  //   print("Selected: $selectedItems");
                  // },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          setState(() => _isLoading = true);

                          try {
                            final selectedApps = blockedAppsController
                                .selectedItems
                                .map((item) => item.value)
                                .toList();

                            final int plannedMinutes =
                                int.tryParse(selectedDuration ?? '') ?? 0;

                            final double penaltyAmount =
                                double.tryParse(penaltyAmountController.text) ??
                                0.0;

                            // 🔥 CALL YOUR PROVIDER HERE
                            final sessionId = context.read<SessionProvider>().startSession(
                              userId: userId,
                              habitCategory: selectedCategory!,
                              plannedMinutes: plannedMinutes,
                              penaltyAmount: penaltyAmount,
                              restrictionLevel: selectedRestrictionLevel!,
                              blockedCategories: selectedApps,
                            );

                            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ActiveSessionScreen(sessionId: sessionId),
                ),
              );

                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Commitment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
