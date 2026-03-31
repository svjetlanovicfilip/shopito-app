import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopito_app/blocs/users/users_bloc.dart';
import 'package:shopito_app/config/injection_container.dart';
import 'package:shopito_app/data/models/user.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final UsersBloc _usersBloc = getIt<UsersBloc>();
  String? selectedRole;
  final List<String> roles = const ['USER', 'ADMIN'];

  @override
  void initState() {
    super.initState();
    _usersBloc.add(const UsersFetch());
  }

  @override
  Widget build(BuildContext context) {
    List<User> filteredUsers = [];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFE91E63),
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: BlocListener<UsersBloc, UsersState>(
          bloc: _usersBloc,
          listener: (context, state) {
            if (state is UsersOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFFE91E63),
                ),
              );
              _usersBloc.add(const UsersFetch(isRefresh: true));
            } else if (state is UsersOperationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<UsersBloc, UsersState>(
            bloc: _usersBloc,
            builder: (context, state) {
              List<User> users = [];
              if (state is UsersLoaded) {
                users = state.users;
              }
              filteredUsers =
                  selectedRole == null
                      ? users
                      : users
                          .where(
                            (user) =>
                                (user.role ?? '').toUpperCase() == selectedRole,
                          )
                          .toList();

              return Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color(0xFFE91E63),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Upravljanje korisnicima",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 24),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // User Stats
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            "Ukupno",
                            "${users.length}",
                            Icons.people_outline,
                            Color(0xFFE91E63),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 2,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _buildStatItem(
                            "Admini",
                            "${users.where((u) => (u.role ?? '').toUpperCase() == 'ADMIN').length}",
                            Icons.admin_panel_settings_outlined,
                            Color(0xFF673AB7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Users List
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is UsersLoading || state is UsersInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is UsersError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            return _buildUserCard(filteredUsers[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF121212),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildUserCard(User user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getRoleColorFromName(
                    user.role,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getRoleIconFromName(user.role),
                  color: _getRoleColorFromName(user.role),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.fullname,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF121212),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColorFromName(
                              user.role,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getRoleTextFromName(user.role),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getRoleColorFromName(user.role),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      user.phone,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _showUserDetails(user),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF1976D2).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.visibility_outlined,
                        color: Color(0xFF1976D2),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _changeUserRole(user),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFE91E63).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        color: Color(0xFFE91E63),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // User Stats
        ],
      ),
    );
  }

  void _showUserDetails(User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // User Avatar and Basic Info
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _getRoleColorFromName(
                                user.role,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              _getRoleIconFromName(user.role),
                              color: _getRoleColorFromName(user.role),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullname,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF121212),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getRoleColorFromName(
                                          user.role,
                                        ).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _getRoleTextFromName(user.role),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _getRoleColorFromName(
                                            user.role,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // removed active badge (not supported by API model)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Contact Info
                      Text(
                        "Kontakt informacije",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF121212),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.email_outlined,
                        "Email",
                        user.email,
                      ),
                      _buildDetailRow(
                        Icons.phone_outlined,
                        "Telefon",
                        user.phone,
                      ),

                      // Omitted account stats (not available from API)
                      const SizedBox(height: 30),

                      // Action Buttons
                      Row(
                        children: [
                          // Removed activate/deactivate button (not in API)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _changeUserRole(user);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFE91E63),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text("Promijeni ulogu"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF121212),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeUserRole(User user) {
    String? newRole =
        (user.role != null && user.role!.isNotEmpty)
            ? user.role!.toUpperCase()
            : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                "Promijeni ulogu",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF121212),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Korisnik: ${user.fullname}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: roles.contains(newRole) ? newRole : null,
                    decoration: InputDecoration(
                      labelText: "Nova uloga",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items:
                        roles
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Row(
                                  children: [
                                    Icon(
                                      _getRoleIconFromName(role),
                                      color: _getRoleColorFromName(role),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(_getRoleTextFromName(role)),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        newRole = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    "Otkaži",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newRole != null) {
                      Navigator.of(context).pop();
                      getIt<UsersBloc>().add(
                        UsersChangeRole(
                          userId: user.id!.toString(),
                          roleName: newRole!,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Sačuvaj"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getRoleTextFromName(String? role) {
    switch ((role ?? '').toUpperCase()) {
      case 'ADMIN':
        return 'Administrator';
      default:
        return 'Korisnik';
    }
  }

  Color _getRoleColorFromName(String? role) {
    switch ((role ?? '').toUpperCase()) {
      case 'ADMIN':
        return const Color(0xFF673AB7);
      default:
        return const Color(0xFF4CAF50);
    }
  }

  IconData _getRoleIconFromName(String? role) {
    switch ((role ?? '').toUpperCase()) {
      case 'ADMIN':
        return Icons.admin_panel_settings_outlined;
      default:
        return Icons.person_outline;
    }
  }
}

// Removed AdminUser and legacy UserRole; using API User model with role: 'USER' | 'ADMIN'
