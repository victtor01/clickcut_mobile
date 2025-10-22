import 'package:clickcut_mobile/features/select/apresentation/controllers/select_business_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SelectBusinessController>().fetchBusinesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SelectBusinessController>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _buildBody(controller),
        ),
      ),
    );
  }

  Widget _buildBody(SelectBusinessController controller) {
    switch (controller.state) {
      case SelectBusinessState.loading:
      case SelectBusinessState.idle:
        return const Center(child: CircularProgressIndicator());

      case SelectBusinessState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Erro ao buscar negócios: ${controller.errorMessage}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchBusinesses(),
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        );

      case SelectBusinessState.success:
        final colorsScheme = Theme.of(context).colorScheme;

        if (controller.businesses.isEmpty) {
          return const Center(child: Text('Nenhum negócio encontrado.'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 70.0, bottom: 40.0, left: 20, right: 20),
              child: Text(
                "Qual negócio deseja acessar?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: controller.businesses.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final business = controller.businesses[index];
                      return FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: Material(
                                borderRadius: BorderRadius.circular(8),
                                color: colorsScheme.surfaceContainer,
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () => controller.selectBusiness(
                                      context, business),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: business.logoUrl != null
                                            ? Ink.image(
                                                image: NetworkImage(
                                                    business.logoUrl!),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              )
                                            : const Icon(Icons.business,
                                                size: 50),
                                      ),
                                      if (business.hasPassword)
                                        Positioned(
                                          bottom: 6,
                                          right: 6,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.lock,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // 3. ADICIONE UM GESTUREDETECTOR AO REDOR DO TEXTO
                            GestureDetector(
                              onTap: () =>
                                  controller.selectBusiness(context, business),
                              // Adiciona um comportamento para o detector de gestos
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                business.name,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      // ### FIM DA UI ESTILO NETFLIX ###
    }
  }
}
