# DeepWiki Q&A with Code Context for Repository: dart-lang/sdk
## Q1
I want to know how hotreload works in dart, how it preserves state that's needed, swap functions, variable, instances without affecting their state
### Answer
## Answer

Dart VM hot reload works by loading a *delta* kernel program alongside the old one, then committing it atomically at a safepoint: old `Class`/`Library` objects are mapped to replacements, functions are swapped via "become" mappings and cache invalidation, static field values are copied across, and live heap instances are *morphed* in place by name-matched field mappings so object identity and state survive. The orchestration lives in `IsolateGroupReloadContext` / `ProgramReloadContext` in `runtime/vm/isolate_reload.h`/`runtime/vm/isolate_reload.cc`.

---

## How it works in detail

### 1. Phased reload pipeline

`ProgramReloadContext` runs reload as explicit phases with a possible rollback:

- `ReloadPhase1AllocateStorageMapsAndCheckpoint()` / `CheckpointClasses()` / `CheckpointLibraries()` — snapshot old libraries/classes.
- `ReloadPhase2LoadDeltaProgram()` — load only the changed kernel ("delta") program.
- `ReloadPhase3FinalizeLoading()` — build new class hierarchies, detect schema changes.
- `ReloadPhase4CommitPrepare()` + `ReloadPhase4CommitFinish()` — atomically swap; or `ReloadPhase4Rollback()` on failure. sdk:318-329 

The whole operation runs under `RELOAD_OPERATION_SCOPE`, which stops the background compiler and brings all mutator threads to a reload safepoint so the heap can't change mid-swap. sdk:438-457 

### 2. Swapping classes and functions

The VM builds old→new mappings via `BuildLibraryMapping()`, `AddClassMapping()`, `AddStaticFieldMapping()`, and `AddBecomeMapping()` (using the `become_` mechanism — a heap primitive that redirects all references from old objects to new ones, so stale references can't linger). sdk:367-378 

`Class` exposes helpers for the swap: `PatchFieldsAndFunctions()`, `MigrateImplicitStaticClosures()` (this is why saved closures still work — old closures are recompiled against a preserved "patch class"), `CopyCanonicalConstants()`, and `CheckReload()` for compatibility validation. sdk:2045-2053 

Test `IsolateReload_SavedClosure` shows this: a closure whose source was deleted still runs and calls the *new* `magic()`, returning `"postapocalyptic!"`. sdk:416-448 

### 3. Preserving state

**Static fields**: `CopyStaticFieldValues()` plus `AddStaticFieldMapping()` copies each old static field's value onto its new counterpart — initializers are *not* re-run. Test `IsolateReload_StaticValuePreserved` proves it: after reload, `init()` returns the new value but `value` keeps `'old value'`. sdk:389-414 

**Instances**: when a class's field layout changes, `InstanceMorpher::CreateFromClassDescriptors()` builds a `FieldMappingArray` matching fields **by name** (types are currently ignored) between the old and new field maps, plus the type-arguments field for generics. sdk:100-122 

All morphers are indexed by class ID in `instance_morpher_by_cid_`, and `ObjectLocator` (an `ObjectVisitor`) walks the entire heap to collect every instance needing morphing. sdk:245-252 sdk:73-93 

Because morphing happens in place, object identity and the reference graph are preserved — the `IsolateReload_ShapeChangeMutualReference` test verifies mutually-referencing instances still see each other after their shape grows from 1 to 4 fields. sdk:4150-4189 

### 4. Making running code see the new functions

Old optimized code can't keep running with new semantics, so the reload context deoptimizes and invalidates:

- `EnsuredUnoptimizedCodeForStack()` / `DeoptimizeDependentCode()` — live stack frames revert to unoptimized code.
- `InvalidateWorld()`, `InvalidateFunctions()`, `InvalidateFields()`, `InvalidateSuspendStates()` — pending `await`/`yield` continuations are patched too.
- `CallSiteResetter` clears inline caches (`ICData`), switchable calls, edge counters, and rebinds bytecode so the next dispatch resolves to the new functions. sdk:315-351 sdk:401-434 

A reload can be refused: `reasons_to_cancel_reload_` collects `ReasonForCancelling` entries (e.g., deleted fields that retained closures still need — see `IsolateReload_CallDeleted_SuperFieldSetter` which surfaces a `NoSuchMethodError` instead of crashing). sdk:248-249 sdk:3549-3553 

## Notes

- Hot reload is compiled out in `PRODUCT` and `DART_PRECOMPILED_RUNTIME` builds — it's a JIT/development-only feature guarded by `#if !defined(PRODUCT) && !defined(DART_PRECOMPILED_RUNTIME)`. sdk:461-463 
- The web has a *separate* system: DDC's `hotReloadEnd()` in `ddc_module_loader.js` reuses existing library objects and re-runs initializers, rather than morphing instances — so don't conflate the two. sdk:1655-1679 
- The snippets I have show phase names and morpher construction, but not the full bodies of `CommitBeforeInstanceMorphing()`/`MorphInstances()` — if you want the exact field-copy loop, a Devin session can pull the complete `isolate_reload.cc`.

Wiki pages you might want to explore:
- [Runtime Systems (dart-lang/sdk)](/wiki/dart-lang/sdk#5)
### Citations
**File:** runtime/vm/isolate_reload.h (L245-252)
```text
  // Collect the necessary instance transformation for schema changes.
  GrowableArray<InstanceMorpher*> instance_morphers_;

  // Collects the reasons for cancelling the reload.
  GrowableArray<ReasonForCancelling*> reasons_to_cancel_reload_;

  // Hash map from cid to InstanceMorpher.
  DirectChainedHashMap<MorpherTrait> instance_morpher_by_cid_;
```
**File:** runtime/vm/isolate_reload.h (L315-351)
```text
  ErrorPtr EnsuredUnoptimizedCodeForStack();
  void DeoptimizeDependentCode();

  void ReloadPhase1AllocateStorageMapsAndCheckpoint();
  void CheckpointClasses();
  ObjectPtr ReloadPhase2LoadDeltaProgram(DeltaProgram* program,
                                         const String& root_lib_url);
  void ReloadPhase3FinalizeLoading();
  void ReloadPhase4CommitPrepare();
  ErrorPtr ReloadPhase4CommitFinish(DeltaProgram* program);
  void ReloadPhase4Rollback();

  void CheckpointLibraries();

  void RollbackLibraries();

  void VerifyMaps();

  void CommitBeforeInstanceMorphing();
  void CommitAfterInstanceMorphing();
  ErrorPtr PostCommit();

  ErrorPtr RunInvalidationVisitors();
  void InvalidateKernelInfos(
      Zone* zone,
      const GrowableArray<const KernelProgramInfo*>& kernel_infos);
  void InvalidateFunctions(Zone* zone,
                           const GrowableArray<const Function*>& functions);
  ErrorPtr InvalidateSuspendStates(
      Zone* zone,
      const GrowableArray<const SuspendState*>& suspend_states);
  void InvalidateFields(Zone* zone,
                        const GrowableArray<const Field*>& fields,
                        const GrowableArray<const Instance*>& instances);
  void ResetUnoptimizedICsOnStack();
  void ResetMegamorphicCaches();
  ErrorPtr InvalidateWorld();
```
**File:** runtime/vm/isolate_reload.h (L367-378)
```text
  void BuildLibraryMapping();
  void BuildRemovedClassesSet();
  void ValidateReload();

  void AddClassMapping(const Class& replacement_or_new, const Class& original);
  void AddLibraryMapping(const Library& replacement_or_new,
                         const Library& original);
  void AddStaticFieldMapping(const Field& old_field, const Field& new_field);
  void AddBecomeMapping(const Object& old, const Object& neu);
  void RestoreClassHierarchyInvariants();

  Become become_;
```
**File:** runtime/vm/isolate_reload.h (L401-434)
```text
class CallSiteResetter : public ValueObject {
 public:
  explicit CallSiteResetter(Zone* zone);

  void ZeroEdgeCounters(const Function& function);
  void ResetCaches(const Code& code);
  void ResetCaches(const ObjectPool& pool);
  void Reset(const ICData& ic);
  void ResetSwitchableCalls(const Code& code);
  void RebindBytecode(const Bytecode& bytecode);

 private:
  Thread* thread_;
  Zone* zone_;
  Instructions& instrs_;
  ObjectPool& pool_;
  Object& object_;
  String& name_;
  Class& old_cls_;
  Class& new_cls_;
  Library& old_lib_;
  Library& new_lib_;
  Function& new_function_;
  Field& new_field_;
  Array& entries_;
  Function& old_target_;
  Function& new_target_;
  Function& caller_;
  Array& args_desc_array_;
  Array& ic_data_array_;
  Array& edge_counters_;
  PcDescriptors& descriptors_;
  ICData& ic_data_;
};
```
**File:** runtime/vm/isolate_reload.h (L438-457)
```text
#define RELOAD_OPERATION_SCOPE(thread_expr)                                    \
  auto _thread_ = (thread_expr);                                               \
                                                                               \
  /* As the background compiler is a mutator it participates in safepoint */   \
  /* operations. Though the BG compiler won't check into reload safepoint */   \
  /* requests - as it's not a well-defined place to do reload.            */   \
  /* So we ensure the background compiler is stopped before we get all    */   \
  /* other mutators to reload safepoints.                                 */   \
  NoBackgroundCompilerScope _stop_bg_compiler_(_thread_);                      \
                                                                               \
  /* This will enable the current thread to perform reload operations (as */   \
  /* well as check-in with other thread's reload operations).             */   \
  ReloadParticipationScope _allow_reload_(_thread_);                           \
                                                                               \
  /* The actual reload operation that will ensure all other mutators are */    \
  /* stopped at well-defined places where reload can happen.             */    \
  ReloadSafepointOperationScope _safepoint_operation_(_thread_);               \
                                                                               \
  /* Native calls during reload should not enter reload safepoints. */         \
  NoReloadScope _no_reload_(_thread_);
```
**File:** runtime/vm/isolate_reload.h (L461-463)
```text
#endif  // !defined(PRODUCT) && !defined(DART_PRECOMPILED_RUNTIME)

#endif  // RUNTIME_VM_ISOLATE_RELOAD_H_
```
**File:** runtime/vm/object.h (L2045-2053)
```text
  void CopyStaticFieldValues(ProgramReloadContext* reload_context,
                             const Class& old_cls) const;
  void PatchFieldsAndFunctions() const;
  void MigrateImplicitStaticClosures(ProgramReloadContext* context,
                                     const Class& new_cls) const;
  void CopyCanonicalConstants(const Class& old_cls) const;
  void CopyDeclarationType(const Class& old_cls) const;
  void CheckReload(const Class& replacement,
                   ProgramReloadContext* context) const;
```
**File:** runtime/vm/isolate_reload_test.cc (L416-448)
```text
TEST_CASE(IsolateReload_SavedClosure) {
  // Create a closure in main which only exists in the original source.
  const char* kScript =
      "magic() {\n"
      "  var x = 'ante';\n"
      "  return x + 'diluvian';\n"
      "}\n"
      "var closure;\n"
      "main() {\n"
      "  closure = () { return magic().toString() + '!'; };\n"
      "  return closure();\n"
      "}\n";

  Dart_Handle lib = TestCase::LoadTestScript(kScript, nullptr);
  EXPECT_VALID(lib);
  EXPECT_STREQ("antediluvian!", SimpleInvokeStr(lib, "main"));

  // Remove the original closure from the source code.  The closure is
  // able to be recompiled because its source is preserved in a
  // special patch class.
  const char* kReloadScript =
      "magic() {\n"
      "  return 'postapocalyptic';\n"
      "}\n"
      "var closure;\n"
      "main() {\n"
      "  return closure();\n"
      "}\n";

  lib = TestCase::ReloadTestScript(kReloadScript);
  EXPECT_VALID(lib);
  EXPECT_STREQ("postapocalyptic!", SimpleInvokeStr(lib, "main"));
}
```
**File:** runtime/vm/isolate_reload_test.cc (L3549-3553)
```text
  lib = TestCase::ReloadTestScript(kReloadScript);
  EXPECT_VALID(lib);
  const char* result = SimpleInvokeStr(lib, "main");
  EXPECT_SUBSTRING("NoSuchMethodError", result);
  EXPECT_SUBSTRING("deleted", result);
```
**File:** runtime/vm/isolate_reload_test.cc (L4150-4189)
```text
TEST_CASE(IsolateReload_ShapeChangeMutualReference) {
  const char* kScript =
      "class A{\n"
      "  var x;\n"
      "  get yourself => this;\n"
      "}\n"
      "var retained1;\n"
      "var retained2;\n"
      "main() {\n"
      "  retained1 = new A();\n"
      "  retained2 = new A();\n"
      "  retained1.x = retained2;\n"
      "  retained2.x = retained1;\n"
      "  return '${identical(retained1.x.yourself, retained2)}'\n"
      "         '${identical(retained2.x.yourself, retained1)}';\n"
      "}\n";

  Dart_Handle lib = TestCase::LoadTestScript(kScript, nullptr);
  EXPECT_VALID(lib);
  EXPECT_STREQ("truetrue", SimpleInvokeStr(lib, "main"));

  const char* kReloadScript =
      "class A{\n"
      "  var x;\n"
      "  var y;\n"
      "  var z;\n"
      "  var w;\n"
      "  get yourself => this;\n"
      "}\n"
      "var retained1;\n"
      "var retained2;\n"
      "main() {\n"
      "  return '${identical(retained1.x.yourself, retained2)}'\n"
      "         '${identical(retained2.x.yourself, retained1)}';\n"
      "}\n";

  lib = TestCase::ReloadTestScript(kReloadScript);
  EXPECT_VALID(lib);
  EXPECT_STREQ("truetrue", SimpleInvokeStr(lib, "main"));
}
```
**File:** runtime/vm/isolate_reload.cc (L73-93)
```text
class ObjectLocator : public ObjectVisitor {
 public:
  explicit ObjectLocator(IsolateGroupReloadContext* context)
      : context_(context), count_(0) {}

  void VisitObject(ObjectPtr obj) override {
    InstanceMorpher* morpher = context_->instance_morpher_by_cid_.LookupValue(
        obj->GetClassIdOfHeapObject());
    if (morpher != nullptr) {
      morpher->AddObject(obj);
      count_++;
    }
  }

  // Return the number of located objects for morphing.
  intptr_t count() { return count_; }

 private:
  IsolateGroupReloadContext* context_;
  intptr_t count_;
};
```
**File:** runtime/vm/isolate_reload.cc (L100-122)
```text
InstanceMorpher* InstanceMorpher::CreateFromClassDescriptors(
    Zone* zone,
    ClassTable* class_table,
    const Class& from,
    const Class& to) {
  auto mapping = new (zone) FieldMappingArray();
  auto new_fields_offsets = new (zone) FieldOffsetArray();

  if (from.NumTypeArguments() > 0) {
    // Add copying of the optional type argument field.
    intptr_t from_offset = from.host_type_arguments_field_offset();
    ASSERT(from_offset != Class::kNoTypeArguments);
    intptr_t to_offset = to.host_type_arguments_field_offset();
    ASSERT(to_offset != Class::kNoTypeArguments);
    mapping->Add({from_offset, kIllegalCid});
    mapping->Add({to_offset, kIllegalCid});
  }

  // Add copying of the instance fields if matching by name.
  // Note: currently the type of the fields are ignored.
  const Array& from_fields = Array::Handle(
      from.OffsetToFieldMap(IsolateGroup::Current()->heap_walk_class_table()));
  const Array& to_fields = Array::Handle(to.OffsetToFieldMap());
```
**File:** runtime/vm/isolate_reload.cc (L389-414)
```text
      THR_Print("[box %s]", BoxCidToCString(from.box_cid));
    } else if (to.box_cid != kIllegalCid) {
      THR_Print("[%s]", BoxCidToCString(from.box_cid));
    }
  }
  THR_Print("\n");
}

void InstanceMorpher::AppendTo(JSONArray* array) {
  JSONObject jsobj(array);
  jsobj.AddProperty("type", "ShapeChangeMapping");
  jsobj.AddProperty64("class-id", cid_);
  jsobj.AddProperty("instanceCount", before_.length());
  JSONArray map(&jsobj, "fieldOffsetMappings");
  for (int i = 0; i < mapping_->length(); i += 2) {
    const auto& from = mapping_->At(i);
    const auto& to = mapping_->At(i + 1);

    JSONArray pair(&map);
    pair.AddValue(from.offset);
    pair.AddValue(to.offset);
    if (to.box_cid == kIllegalCid && from.box_cid != kIllegalCid) {
      pair.AddValueF("box %s", BoxCidToCString(from.box_cid));
    } else if (to.box_cid != kIllegalCid) {
      pair.AddValueF("%s", BoxCidToCString(from.box_cid));
    }
```
**File:** pkg/dev_compiler/lib/js/ddc/ddc_module_loader.js (L1655-1679)
```javascript
    hotReloadEnd() {
      // Clear RTI subtype caches before initializing libraries.
      // These needs to be done before hot reload completes (and any new
      // libraries initialize) in case subtype hierarchies updated.
      let dartRtiLibrary = this.importLibrary('dart:_rti');
      dartRtiLibrary.resetRtiSubtypeCaches();

      // On a hot reload, we reuse the existing library objects to ensure all
      // references remain valid and continue to be unique. We track in
      // `previouslyLoaded` which libraries already exist in the system, so we
      // can properly initialize and link them with the new version of the code.
      let previouslyLoaded = Object.create(null);
      for (let name of this.pendingHotReloadLibraryNames) {
        previouslyLoaded[name] = (this.libraries[name] != null);
      }

      // All initializers are updated, but only libraries that were previously
      // loaded need to be reinitialized.
      for (let name of this.pendingHotReloadLibraryNames) {
        let initializer = this.pendingHotReloadLibraryInitializers[name];
        this.libraryInitializers[name] = initializer;
        if (previouslyLoaded[name]) {
          initializer(this.libraries[name]);
        }
      }
```