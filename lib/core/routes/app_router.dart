import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart'; // Tambahan ini
import '../../features/dashboard/presentation/pages/admin_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/user_dashboard_page.dart';
import '../../features/saving/presentation/pages/deposit_page.dart';
import '../../features/saving/presentation/pages/history_page.dart';
import '../../features/loan/presentation/pages/loan_form_page.dart';
import '../../features/loan/presentation/pages/loan_review_page.dart';
import '../../features/loan/presentation/pages/installment_payment_page.dart';
import '../../features/dashboard/presentation/pages/admin_members_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register', // Tambahan blok rute ini
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/user-dashboard',
      builder: (context, state) => const UserDashboardPage(),
    ),
    GoRoute(
      path: '/deposit',
      builder: (context, state) => const DepositPage(),
    ),
    GoRoute(
      path: '/loan-form',
      builder: (context, state) => const LoanFormPage(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryPage(),
    ),
    GoRoute(
      path: '/installment-payment',
      builder: (context, state) => const InstallmentPaymentPage(),
    ),
    GoRoute(
      path: '/admin-dashboard',
      builder: (context, state) => const AdminDashboardPage(),
    ),
    GoRoute(
      path: '/loan-review',
      builder: (context, state) => const LoanReviewPage(),
    ),
    GoRoute(
      path: '/admin-members',
      builder: (context, state) => const AdminMembersPage(),
    ),
  ],
);